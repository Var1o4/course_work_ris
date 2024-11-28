package com.example.course_like_erip.services;

import com.example.course_like_erip.dto.PaymentXmlDTO;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.ActionType;
import com.example.course_like_erip.repositories.PaymentRepository;
import com.example.course_like_erip.repositories.UserRepository;


import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class PaymentService {
    private final PaymentRepository paymentRepository;
    private final UserRepository userRepository;
    private final InvoiceService invoiceService;
    private final OperationService operationService;
    private final HistoryService historyService;
    private final NotificationService notificationService;

    public List<Payment> getRootPaymentGroups() {
        return paymentRepository.findByParentPaymentIsNull();
    }

    public List<Payment> getPaymentsByParentId(Long parentId) {
        if (parentId == null) {
            throw new RuntimeException("ID родительской группы не может быть null");
        }
        Payment parentPayment = getPaymentById(parentId);
        return paymentRepository.findByParentPayment(parentPayment);
    }

    public Payment getPaymentById(Long id) {
        return paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Платеж не найден"));
    }

    public User getUserByPrincipal(Principal principal) {
        if (principal == null) {
            throw new RuntimeException("Principal не может быть null");
        }
        return userRepository.findByEmail(principal.getName());
    }

    public List<Payment> getPaymentsByUser(User user) {
        if (user.hasRole("ROLE_ADMIN")) {
            return paymentRepository.findAll();
        }
        return paymentRepository.findByUserOrRecipient(user.getId());
    }

    @Transactional
    public Payment savePayment(Payment payment, Principal principal, HttpServletRequest request) {
        log.info("Attempting to save payment: {}", payment);
        validatePayment(payment);
        User user = getUserByPrincipal(principal);
        payment.setUser(user);
        payment.setStatus("ACTIVE");
        Payment savedPayment = paymentRepository.save(payment);
        log.info("Payment saved successfully: {}", savedPayment);
historyService.saveHistory(
        "payments",
        null,
        "Создан платеж: " + payment.getName(),
        user,
        "name, amount, description",
        ActionType.CREATE,
        savedPayment.getId(),
        request.getRemoteAddr(),
        request.getHeader("User-Agent")
    );

        return savedPayment;
    }

    private void validatePayment(Payment payment) {
        log.info("Validating payment: {}", payment);
        if (payment.isGroup()) {
            if (payment.getAmount() != null) {
                log.error("Group payment cannot have amount");
                throw new RuntimeException("Группа платежей не может иметь сумму");
            }
        } else {
            if (payment.getParentPayment() == null && !payment.getName().startsWith("Импортированные платежи")) {
                log.error("Non-group payment must have parent");
                throw new RuntimeException("Платёж должен принадлежать группе");
            }
            if (payment.getAmount() == null || payment.getAmount() <= 0) {
                log.error("Payment must have valid amount");
                throw new RuntimeException("Платёж должен иметь корректную сумму");
            }
        }
        log.info("Payment validation successful");
    }

    @Transactional
    public Payment updatePayment(Long id, Payment updatedPayment) {
        Payment payment = getPaymentById(id);
        validatePayment(updatedPayment);
        
        payment.setName(updatedPayment.getName());
        payment.setDescription(updatedPayment.getDescription());
        payment.setAmount(updatedPayment.isGroup() ? null : updatedPayment.getAmount());
        payment.setFixedPrice(updatedPayment.isFixedPrice());
        payment.setGroup(updatedPayment.isGroup());
        payment.setParentPayment(updatedPayment.isGroup() ? null : updatedPayment.getParentPayment());
        
        return paymentRepository.save(payment);
    }

    @Transactional
    public void deletePayment(Long id) {
        Payment payment = getPaymentById(id);
        if (payment.isGroup()) {
            deletePaymentGroup(payment);
        }
        paymentRepository.delete(payment);
    }

    private void deletePaymentGroup(Payment group) {
        for (Payment child : new ArrayList<>(group.getChildPayments())) {
            if (child.isGroup()) {
                deletePaymentGroup(child);
            }
            paymentRepository.delete(child);
        }
    }

    @Transactional
    public void processPayment(Long paymentId, Long invoiceId, BigDecimal amount, HttpServletRequest request) {
        Payment payment = getPaymentById(paymentId);
        Invoice sourceInvoice = invoiceService.getInvoiceById(invoiceId);
        
        // Проверяем валидность платежа
        validatePayment(payment);
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            log.error("Payment amount must be positive");
            throw new RuntimeException("Сумма платежа должна быть положительной");
        }
        
        // Обрабатываем операции
        operationService.processPayment(payment, sourceInvoice, amount, request);
        // Обновляем статус платежа
        payment.setStatus("PAID");
        paymentRepository.save(payment);
    }

    public List<String> getPaymentGroupPaths() {
        List<Payment> rootGroups = getRootPaymentGroups();
        List<String> paths = new ArrayList<>();
        
        for (Payment rootGroup : rootGroups) {
            buildGroupPath(rootGroup, rootGroup.getName(), paths);
        }
        
        return paths;
    }

    private void buildGroupPath(Payment group, String currentPath, List<String> paths) {
        paths.add(currentPath + "|" + group.getId());
        
        for (Payment child : group.getChildPayments()) {
            if (child.isGroup()) {
                buildGroupPath(child, currentPath + "/" + child.getName(), paths);
            }
        }
    }

    @Transactional
    public void processXmlPayments(PaymentXmlDTO paymentData, Principal principal, HttpServletRequest request) {
        log.info("Starting XML payments processing");
        try {
            Payment rootGroup = getRootGroupForImport();
            User creator = getUserByPrincipal(principal);
            
            for (PaymentXmlDTO.PaymentEntry entry : paymentData.getPayments()) {
                log.info("Processing payment entry: {}", entry);
                
                User recipient = userRepository.findByEmail(entry.getUserEmail());
                if (recipient == null) {
                    log.error("User not found: {}", entry.getUserEmail());
                    continue;
                }
                
                try {
                    Payment payment = Payment.builder()
                            .name(entry.getName())
                            .description(entry.getDescription())
                            .amount(entry.getAmount())
                            .status("ACTIVE")
                            .group(false)
                            .fixedPrice(true)
                            .user(creator)
                            .recipient(recipient)
                            .parentPayment(rootGroup)
                            .paymentDueDate(entry.getDueDate())
                            .build();
                    
                    savePayment(payment, principal, request);
                } catch (Exception e) {
                    log.error("Error saving payment", e);
                }
            }
        } catch (Exception e) {
            log.error("Error processing payments", e);
            throw e;
        }
    }

    private Payment getRootGroupForImport() {
        // Ищем существующую группу или создаем новую
        Payment rootGroup = paymentRepository.findByNameAndGroupTrue("Импортированные платежи");
        if (rootGroup == null) {
            rootGroup = Payment.builder()
                    .name("Импортированные платежи")
                    .description("Группа для импортированных платежей")
                    .group(true)
                    .status("ACTIVE")
                    .build();
            paymentRepository.save(rootGroup);
            log.info("Created root group for imported payments with ID: {}", rootGroup.getId());
        }
        return rootGroup;
    }
} 
