package com.example.course_like_erip.services;

import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.repositories.PaymentRepository;
import com.example.course_like_erip.repositories.UserRepository;
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
        return paymentRepository.findByUser(user);
    }

    @Transactional
    public Payment savePayment(Payment payment, Principal principal) {
        log.info("Attempting to save payment: {}", payment);
        validatePayment(payment);
        User user = getUserByPrincipal(principal);
        payment.setUser(user);
        payment.setStatus("ACTIVE");
        Payment savedPayment = paymentRepository.save(payment);
        log.info("Payment saved successfully: {}", savedPayment);
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
            if (payment.getParentPayment() == null) {
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
    public void processPayment(Long paymentId, Long invoiceId, BigDecimal amount) {
        Payment payment = getPaymentById(paymentId);
        Invoice sourceInvoice = invoiceService.getInvoiceById(invoiceId);
        
        // Проверяем валидность платежа
        validatePayment(payment);
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            log.error("Payment amount must be positive");
            throw new RuntimeException("Сумма платежа должна быть положительной");
        }
        
        // Обрабатываем операции
        operationService.processPayment(payment, sourceInvoice, amount);
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
} 