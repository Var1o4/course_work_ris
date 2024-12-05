package com.example.course_like_erip.controllers;

import com.example.course_like_erip.dto.PaymentProcessDTO;
import com.example.course_like_erip.dto.PaymentXmlDTO;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.InvoiceStatus;
import com.example.course_like_erip.services.InvoiceService;
import com.example.course_like_erip.services.PaymentService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.Unmarshaller;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.nio.file.AccessDeniedException;
import java.security.Principal;
import java.util.List;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;
import java.io.StringReader;
import java.io.Reader;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;

@Controller
@RequestMapping("/payments")
@RequiredArgsConstructor
public class PaymentController {
    private final PaymentService paymentService;
    private final InvoiceService invoiceService;
    private static final Logger log = LoggerFactory.getLogger(PaymentController.class);

    @GetMapping("/groups")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_USER')")
    public String getPaymentGroups(Principal principal, Model model) {
        User user = paymentService.getUserByPrincipal(principal);
        List<Payment> rootGroups = paymentService.getRootPaymentGroups();
        model.addAttribute("payments", rootGroups);
        model.addAttribute("user", user);
        return "payments/payment-groups";
    }

    @GetMapping("/groups/{groupId}")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_USER')")
    public String getPaymentGroupContent(@PathVariable Long groupId, Principal principal, Model model) {
        User user = paymentService.getUserByPrincipal(principal);
        Payment group = paymentService.getPaymentById(groupId);
        List<Payment> subGroups = paymentService.getPaymentsByParentId(groupId);
        model.addAttribute("currentGroup", group);
        model.addAttribute("payments", subGroups);
        model.addAttribute("user", user);
        return "payments/payment-groups";
    }

    @GetMapping("/create")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String createPaymentForm(Model model) {
        model.addAttribute("payment", new Payment());
        model.addAttribute("groupPaths", paymentService.getPaymentGroupPaths());
        return "payments/payment-form";
    }

    @PostMapping("/create")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String createPayment(@ModelAttribute Payment payment, 
                              Principal principal,
                              HttpServletRequest request) {
        paymentService.savePayment(payment, principal, request);
        return "redirect:/payments/groups";
    }

    @GetMapping("/edit/{id}")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_URFACE')")
    public String editPaymentForm(@PathVariable Long id, Principal principal, Model model) {
        Payment payment = paymentService.getPaymentById(id);
        User user = paymentService.getUserByPrincipal(principal);
        
        if (!user.hasRole("ROLE_ADMIN") && 
            !payment.getUser().getId().equals(user.getId())) {
            throw new org.springframework.security.access.AccessDeniedException(
                "У вас нет прав на редактирование этого платежа"
            );
        }
        
        model.addAttribute("payment", payment);
        model.addAttribute("groups", paymentService.getRootPaymentGroups());
        model.addAttribute("selectedGroup", payment.getParentPayment());
        model.addAttribute("groupPaths", paymentService.getPaymentGroupPaths());
        return "payments/payment-form";
    }

    @PostMapping("/edit/{id}")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_URFACE')")
    public String editPayment(@PathVariable Long id, @ModelAttribute Payment payment, Principal principal) {
        User user = paymentService.getUserByPrincipal(principal);
        Payment existingPayment = paymentService.getPaymentById(id);
        
        if (!user.hasRole("ROLE_ADMIN") && 
            !payment.getUser().getId().equals(user.getId())) {
            throw new org.springframework.security.access.AccessDeniedException(
                "У вас нет прав на редактирование этого платежа"
            );
        }
        
        paymentService.updatePayment(id, payment);
        return "redirect:/payments/groups";
    }

    @PostMapping("/delete/{id}")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_URFACE')")
    public String deletePayment(@PathVariable Long id, Principal principal) {
        User user = paymentService.getUserByPrincipal(principal);
        Payment payment = paymentService.getPaymentById(id);
        
        if (!user.hasRole("ROLE_ADMIN") && 
            !payment.getUser().getId().equals(user.getId())) {
            throw new org.springframework.security.access.AccessDeniedException(
                "У вас нет прав на удаление этого платежа"
            );
        }
        
        paymentService.deletePayment(id);
        return "redirect:/payments/groups";
    }

    @GetMapping("/my")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_USER')")
    public String getMyPayments(Principal principal, Model model) {
        User user = paymentService.getUserByPrincipal(principal);
        List<Payment> payments = paymentService.getPaymentsByUser(user);
        model.addAttribute("payments", payments);
        model.addAttribute("user", user);
        return "payments/my-payments";
    }

    @GetMapping("/view/{id}")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_USER', 'ROLE_URFACE')")
    public String viewPayment(@PathVariable Long id, Principal principal, Model model) {
        Payment payment = paymentService.getPaymentById(id);
        User user = paymentService.getUserByPrincipal(principal);
        model.addAttribute("payment", payment);
        model.addAttribute("user", user);
        return "payments/payment-view";
    }

    @GetMapping("/{id}/pay")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER' , 'ROLE_URFACE')")
    public String showPaymentForm(@PathVariable Long id, Principal principal, Model model) {
        User user = paymentService.getUserByPrincipal(principal);
        Payment payment = paymentService.getPaymentById(id);
        
        // Получаем список активных счетов поьзователя
        List<Invoice> userInvoices = invoiceService.findActiveInvoicesByUser(user);
        
        // Логирование информации о счетах пользователя
        System.out.println("Получение счетов для пользователя: " + user.getEmail());
        System.out.println("Количество активных счетов: " + userInvoices.size());
        
        for (Invoice invoice : userInvoices) {
            System.out.println("Счет #" + invoice.getInvoiceId() + ":");
            System.out.println("  - Баланс: " + invoice.getAmount() + " BYN");
            System.out.println("  - Основной счет: " + invoice.isMainAccount());
            System.out.println("  - Дата создания: " + invoice.getCreatedDate());
            System.out.println("  - Статус: " + invoice.getStatus());
        }

        model.addAttribute("payment", payment);
        model.addAttribute("invoices", userInvoices);
        model.addAttribute("user", user);
        
        return "payments/payment-pay";
    }

    @PostMapping("/{id}/process")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER' , 'ROLE_URFACE')")
    public String processPayment(@PathVariable Long id,
                               @ModelAttribute("paymentForm") PaymentProcessDTO dto,
                               Principal principal, 
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        log.info("Processing payment request for payment ID: {}, invoice ID: {}, amount: {}", 
                 id, dto.getInvoiceId(), dto.getAmount());
        try {
            User user = paymentService.getUserByPrincipal(principal);
            Payment payment = paymentService.getPaymentById(id);
            Invoice sourceInvoice = invoiceService.getInvoiceById(dto.getInvoiceId());
            
            // Проверяем, что счет принадлежит пользователю
            if (!sourceInvoice.getContract().getUser().equals(user)) {
                throw new AccessDeniedException("У вас нет прав на использование этого счета");
            }
            
            // Проверяем валюту счета
            if (!sourceInvoice.isNationalCurrency()) {
                throw new RuntimeException("Оплата возможна только со счетов в белорусских рублях");
            }
            
            BigDecimal paymentAmount;
        // Для фиксированных платежей берем сумму из платежа
        if (payment.isFixedPrice() && payment.getRecipient() == null) {
            paymentAmount = BigDecimal.valueOf(payment.getAmount());
        } else {
            paymentAmount = dto.getAmount();
        }
            
            // Проверяем достаточность средств
            if (sourceInvoice.getAmount().compareTo(paymentAmount) < 0) {
                throw new RuntimeException("Недостаточно средств на счете");
            }
            
            paymentService.processPayment(id, sourceInvoice.getInvoiceId(), paymentAmount, request);
            redirectAttributes.addFlashAttribute("success", "Платеж успеш��о выполнен");
            
            return payment.getRecipient() != null ? "redirect:/payments/my" : "redirect:/payments/groups";
            
        } catch (Exception e) {
            log.error("Error processing payment: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/payments/" + id + "/pay";
        }
    }

    @PostMapping("/upload")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_URFACE')")
    public String uploadPayments(@RequestParam("xmlFile") MultipartFile file,
                       Principal principal,
                       HttpServletRequest request) {
        try {
            // Логируем исходную кодировку файла
            log.info("Original file name: {}", file.getOriginalFilename());
            log.info("Content type: {}", file.getContentType());
            
            // Читаем содержимое файла в разных кодировках для диагностики
            String contentUtf8 = new String(file.getBytes(), StandardCharsets.UTF_8);
            String contentWindows = new String(file.getBytes(), Charset.forName("windows-1251"));
            
            log.info("Content in UTF-8: {}", contentUtf8);
            log.info("Content in Windows-1251: {}", contentWindows);
            
            JAXBContext context = JAXBContext.newInstance(PaymentXmlDTO.class);
            Unmarshaller unmarshaller = context.createUnmarshaller();
            
            // Пробуем разные варианты чтения XML
            PaymentXmlDTO paymentData;
            try {
                // Сначала пробуем UTF-8
                paymentData = (PaymentXmlDTO) unmarshaller.unmarshal(
                    new ByteArrayInputStream(file.getBytes())
                );
                log.info("Successfully unmarshalled with default encoding");
            } catch (Exception e) {
                log.error("Failed to unmarshal with default encoding, trying Windows-1251");
                // Если не получилось, пробуем windows-1251
                String content = new String(file.getBytes(), Charset.forName("windows-1251"));
                paymentData = (PaymentXmlDTO) unmarshaller.unmarshal(new StringReader(content));
            }
            
            // Логируем результат unmarshalling
            log.info("Unmarshalled payment name: {}", paymentData.getPayments().get(0).getName());
            log.info("Unmarshalled payment description: {}", paymentData.getPayments().get(0).getDescription());
            
            paymentService.processXmlPayments(paymentData, principal, request);
            return "redirect:/payments/my?success=true";
        } catch (Exception e) {
            log.error("Error processing XML file: ", e);
            return "redirect:/payments/my?error=" + 
                   URLEncoder.encode("Ошибка обработки файла: " + e.getMessage(), StandardCharsets.UTF_8);
        }
    }
}
