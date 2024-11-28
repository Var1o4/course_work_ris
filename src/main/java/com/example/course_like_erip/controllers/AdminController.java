package com.example.course_like_erip.controllers;


import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.Role;
import com.example.course_like_erip.services.UserService;
import com.example.course_like_erip.services.ContractService;
import com.example.course_like_erip.services.InvoiceService;
import com.example.course_like_erip.services.PaymentService;
import com.example.course_like_erip.services.TestDataCreator;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ROLE_ADMIN')")
@RequiredArgsConstructor
public class AdminController {
    
    private final UserService userService;
    private final TestDataCreator testDataCreator;
    private final InvoiceService invoiceService;
    private final PaymentService paymentService;
    private final ContractService contractService;
    
    
    @GetMapping("/users")
    public String getUsersList(@RequestParam(required = false) String role, Model model) {
        List<User> users;
        String selectedRole = "";
        
        if ("ROLE_USER".equals(role)) {
            users = userService.getUsersByRole(Role.ROLE_USER);
            selectedRole = "ROLE_USER";
        } else if ("ROLE_URFACE".equals(role)) {
            users = userService.getUsersByRole(Role.ROLE_URFACE);
            selectedRole = "ROLE_URFACE";
        } else {
            users = userService.getAllVerifiedUsers();
        }
        
        model.addAttribute("users", users);
        model.addAttribute("selectedRole", selectedRole);
        return "admin/users-list";
    }
    
    @GetMapping("/users/{id}")
    public String getUserDetails(@PathVariable Long id, Model model) {
        User user = userService.getUserById(id);
        
        // Получаем все счета пользователя через контракты
        List<Contract> contracts = contractService.getContractsByUser(user);
        List<Invoice> userInvoices = new ArrayList<>();
        
        for (Contract contract : contracts) {
            userInvoices.addAll(invoiceService.getInvoicesByContract(contract));
        }
        
        // Если пользователь URFACE, получаем его платежи
        if (user.getRoles().contains(Role.ROLE_URFACE)) {
            List<Payment> userPayments = paymentService.getPaymentsByUser(user);
            model.addAttribute("payments", userPayments);
        }
        
        model.addAttribute("user", user);
        model.addAttribute("userInvoices", userInvoices);
        model.addAttribute("roleUrface", Role.ROLE_URFACE);
        
        return "admin/user-details";
    }
    
    @PostMapping("/users/{id}/toggle-ban")
    public String toggleUserBan(@PathVariable Long id, HttpServletRequest request) {
        userService.toggleUserBan(id, request);
        return "redirect:/admin/users";
    }

    @GetMapping("/suspicious-users")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String getSuspiciousUsers(Model model) {
        List<Map<String, Object>> suspiciousUsers = userService.getSuspiciousUsers();
        model.addAttribute("suspiciousUsers", suspiciousUsers);
        return "admin/suspicious-users";
    }

    @GetMapping("/admin/create-test-data")
public String createTestData() {
    testDataCreator.createSuspiciousUserTestData();
    return "redirect:/admin/users";
}
} 