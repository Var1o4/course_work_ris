package com.example.course_like_erip.controllers;

import com.example.course_like_erip.dto.PaymentProcessDTO;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.InvoiceStatus;
import com.example.course_like_erip.services.InvoiceService;
import com.example.course_like_erip.services.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.nio.file.AccessDeniedException;
import java.security.Principal;
import java.util.List;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/payments")
@RequiredArgsConstructor
public class PaymentController {
    private final PaymentService paymentService;
    private final InvoiceService invoiceService;

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
    public String createPayment(@ModelAttribute Payment payment, Principal principal) {
        paymentService.savePayment(payment, principal);
        return "redirect:/payments/groups";
    }

    @GetMapping("/edit/{id}")
    @PreAuthorize("hasRole('ROLE_URFACE')")
    public String editPaymentForm(@PathVariable Long id, Principal principal, Model model) {
        Payment payment = paymentService.getPaymentById(id);
        User user = paymentService.getUserByPrincipal(principal);
        if (!payment.getUser().getId().equals(user.getId())) {
            throw new org.springframework.security.access.AccessDeniedException("У вас нет прав на редактирование этого платежа");
        }
        
        model.addAttribute("payment", payment);
        model.addAttribute("groups", paymentService.getRootPaymentGroups());
        return "payments/payment-form";
    }

    @PostMapping("/edit/{id}")
    @PreAuthorize("hasRole('ROLE_URFACE')")
    public String editPayment(@PathVariable Long id, @ModelAttribute Payment payment, Principal principal) {
        User user = paymentService.getUserByPrincipal(principal);
        Payment existingPayment = paymentService.getPaymentById(id);
        if (!existingPayment.getUser().getId().equals(user.getId())) {
            throw new org.springframework.security.access.AccessDeniedException("У вас нет прав на редактирование этого платежа");
        }
        
        paymentService.updatePayment(id, payment);
        return "redirect:/payments/groups";
    }

    @PostMapping("/delete/{id}")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_URFACE')")
    public String deletePayment(@PathVariable Long id, Principal principal) {
        User user = paymentService.getUserByPrincipal(principal);
        Payment payment = paymentService.getPaymentById(id);
        if (user.hasRole("ROLE_URFACE") && !payment.getUser().getId().equals(user.getId())) {
            throw new org.springframework.security.access.AccessDeniedException("У вас нет прав на удаление этого платежа");
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
    @PreAuthorize("hasAnyRole('ROLE_USER')")
    public String showPaymentForm(@PathVariable Long id, Principal principal, Model model) {
        User user = paymentService.getUserByPrincipal(principal);
        Payment payment = paymentService.getPaymentById(id);
        
        // Получаем список активных счетов пользователя
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
    @PreAuthorize("hasAnyRole('ROLE_USER')")
    public String processPayment(@PathVariable Long id,
                               @ModelAttribute("paymentForm") PaymentProcessDTO dto,
                               Principal principal) {
        User user = paymentService.getUserByPrincipal(principal);
        Payment payment = paymentService.getPaymentById(id);
        Invoice sourceInvoice = invoiceService.getInvoiceById(dto.getInvoiceId());
        
        // Проверяем, что счет принадлежит пользователю
        if (!sourceInvoice.getContract().getUser().equals(user)) {
            throw new org.springframework.security.access.AccessDeniedException("У вас нет прав на использование этого счета");
        }
        
        // Проверяем сумму для платежа с фиксированной ценой
        if (payment.isFixedPrice() && !payment.getAmount().equals(dto.getAmount())) {
            throw new RuntimeException("Сумма платежа должна быть равна " + payment.getAmount());
        }
        
        try {
            paymentService.processPayment(id, dto.getInvoiceId(), dto.getAmount());
            return "redirect:/payments/my?success=true";
        } catch (Exception e) {
            return "redirect:/payments/" + id + "/pay?error=" + 
                   URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
        }
    }
}
