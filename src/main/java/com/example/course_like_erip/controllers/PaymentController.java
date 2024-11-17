package com.example.course_like_erip.controllers;

import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.services.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.nio.file.AccessDeniedException;
import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/payments")
@RequiredArgsConstructor
public class PaymentController {
    private final PaymentService paymentService;

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

    @PostMapping("/{id}/pay")
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_USER')")
    public String makePayment(@PathVariable Long id, @RequestParam(required = false) Double amount, Principal principal) {
        paymentService.processPayment(id, amount, principal);
        return "redirect:/payments/my";
    }
}
