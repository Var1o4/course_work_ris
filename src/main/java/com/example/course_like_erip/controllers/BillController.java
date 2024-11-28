package com.example.course_like_erip.controllers;




import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.ContractStatus;
import com.example.course_like_erip.services.ContractService;
import com.example.course_like_erip.services.UserService;

import jakarta.servlet.http.HttpServletRequest;

import com.example.course_like_erip.services.InvoiceService;
import com.example.course_like_erip.services.OperationService;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Operation;
import com.example.course_like_erip.models.Enum.InvoiceStatus;
import com.example.course_like_erip.models.Enum.Role;
import com.example.course_like_erip.dto.MonthlyExpenseDTO;

import lombok.RequiredArgsConstructor;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.AccessDeniedException;
import java.security.Principal;
import javax.security.auth.login.AccountException;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/bills")
public class BillController {
    private final UserService userService;
    private final ContractService contractService;
    private final InvoiceService invoiceService;
    private final OperationService operationService;

    @GetMapping
    public String getBills(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        Contract contract = contractService.getActiveContractByUser(user);
        
        model.addAttribute("user", user);
        model.addAttribute("contract", contract);
        model.addAttribute("bills", contract != null ? 
            invoiceService.getInvoicesByContract(contract) : null);
        
        return "bills/bills-list";
    }

    @PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE')")
    @GetMapping("/create")
    public String createBillForm(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        Contract contract = contractService.getActiveContractByUser(user);
        
        if (contract == null || contract.getStatus() != ContractStatus.ACTIVE) {
            return "redirect:/bills?error=no_active_contract";
        }
        
        model.addAttribute("contract", contract);
        return "bills/bill-form";
    }

    @PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE')")
    @PostMapping("/create")
    public String createBill(
            @RequestParam BigDecimal amount,
            @RequestParam boolean isNationalCurrency,
            Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        Contract contract = contractService.getActiveContractByUser(user);
        
        if (contract == null || contract.getStatus() != ContractStatus.ACTIVE) {
            return "redirect:/bills?error=no_active_contract";
        }
        
        invoiceService.createInvoice(contract, amount, isNationalCurrency);
        return "redirect:/bills";
    }

    @PostMapping("/{id}/freeze")
    @PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE', 'ROLE_ADMIN')")
    public String freezeInvoice(@PathVariable Long id, 
                               Principal principal,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        try {
            User currentUser = userService.getUserByPrincipal(principal);
            Invoice invoice = invoiceService.getInvoiceById(id);
            
            boolean isOwner = invoice.getContract().getUser().equals(currentUser);
            boolean isAdmin = currentUser.getRoles().contains(Role.ROLE_ADMIN);
            
            if (!isOwner && !isAdmin) {
                throw new AccessDeniedException("У вас нет прав на управление этим счетом");
            }
            
            invoiceService.updateInvoiceStatus(id, InvoiceStatus.FROZEN, request);
            redirectAttributes.addFlashAttribute("success", "Счет успешно заморожен");
            
            return "redirect:/bills/" + id + "/details";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/bills/" + id + "/details";
        }
    }

    @GetMapping("/{id}/details")
    public String getBillDetails(@PathVariable Long id, Principal principal, Model model) {
        log.info("Getting bill details for bill ID: {}", id);
        
        User currentUser = userService.getUserByPrincipal(principal);
        Invoice bill = invoiceService.getInvoiceById(id);
        
        // Проверяем, является ли текущий пользователь владельцем счета или админом
        boolean isOwner = bill.getContract().getUser().equals(currentUser);
        boolean isAdmin = currentUser.getRoles().contains(Role.ROLE_ADMIN);
        if (!isOwner && !isAdmin) {
            throw new org.springframework.security.access.AccessDeniedException("У вас нет прав для просмотра этого счета");
        }
        
        List<Operation> transactions = operationService.getOperationsByBill(bill);
        log.info("Found {} transactions for bill {}", transactions.size(), id);
        
        List<MonthlyExpenseDTO> monthlyExpenses = operationService.getMonthlyExpenses(transactions, 5);
        log.info("Calculated monthly expenses: {}", monthlyExpenses);
        
        model.addAttribute("bill", bill);
        model.addAttribute("transactions", transactions);
        model.addAttribute("monthlyExpenses", monthlyExpenses);
        
        // Добавляем список счетов для перевода только если текущий пользователь - владелец
        if (isOwner) {
            model.addAttribute("userInvoices", invoiceService.findActiveInvoicesByUser(currentUser));
        }
        
        model.addAttribute("isOwner", isOwner);
        model.addAttribute("user", currentUser);
        
        return "bills/bill-details";
    }

    @PostMapping("/{id}/unfreeze")
@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE', 'ROLE_ADMIN')")
public String unfreezeInvoice(@PathVariable Long id, 
                           Principal principal,
                           HttpServletRequest request,
                           RedirectAttributes redirectAttributes) {
    try {
        User currentUser = userService.getUserByPrincipal(principal);
        Invoice invoice = invoiceService.getInvoiceById(id);
        
        boolean isOwner = invoice.getContract().getUser().equals(currentUser);
        boolean isAdmin = currentUser.getRoles().contains(Role.ROLE_ADMIN);
        
        if (!isOwner && !isAdmin) {
            throw new AccessDeniedException("У вас нет прав на управление этим счетом");
        }
        
        invoiceService.updateInvoiceStatus(id, InvoiceStatus.ACTIVE, request);
        redirectAttributes.addFlashAttribute("success", "Счет успешно разморожен");
        
        return "redirect:/bills/" + id + "/details";
        
    } catch (Exception e) {
        redirectAttributes.addFlashAttribute("error", e.getMessage());
        return "redirect:/bills/" + id + "/details";
    }
}

    
@PostMapping("/{id}/set-main")
@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE', 'ROLE_ADMIN')")
public String setMainAccount(@PathVariable Long id, Principal principal) {
    User currentUser = userService.getUserByPrincipal(principal);
    Invoice invoice = invoiceService.getInvoiceById(id);
    
    boolean isOwner = invoice.getContract().getUser().equals(currentUser);
    boolean isAdmin = currentUser.getRoles().contains(Role.ROLE_ADMIN);
    if (!isOwner && !isAdmin) {
        throw new org.springframework.security.access.AccessDeniedException("У вас нет прав на управление этим счетом");
    }
    
    invoiceService.setMainAccount(id, invoice.getContract());
    return "redirect:/bills/" + id + "/details";
}

@PostMapping("/{id}/transfer")
@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE')") 
public String transferMoney(
        @PathVariable Long id,
        @RequestParam Long targetInvoiceId,
        @RequestParam BigDecimal amount,
        Principal principal,
        RedirectAttributes redirectAttributes) {
    try {
        User user = userService.getUserByPrincipal(principal);
        Invoice sourceInvoice = invoiceService.getInvoiceById(id);
        Invoice targetInvoice = invoiceService.getInvoiceById(targetInvoiceId);

        System.out.println("Счет #" + sourceInvoice.getInvoiceId() + ":");
        System.out.println("  - Баланс: " + sourceInvoice.getAmount() + " BYN");
        System.out.println("  - Основной счет: " + sourceInvoice.isMainAccount());
        System.out.println("  - Дата создания: " + sourceInvoice.getCreatedDate());
        System.out.println("  - Статус: " + sourceInvoice.getStatus());
        
        System.out.println("Счет #" + targetInvoice.getInvoiceId() + ":");
        System.out.println("  - Баланс: " + targetInvoice.getAmount() + " BYN");
        System.out.println("  - Основной счет: " + targetInvoice.isMainAccount());
        System.out.println("  - Дата создания: " + targetInvoice.getCreatedDate());
        System.out.println("  - Статус: " + targetInvoice.getStatus());
        
       

        // Проверяем права доступа к исходному счету
        if (!sourceInvoice.getContract().getUser().equals(user)) {
            throw new AccessDeniedException("У вас нет прав на управление этим счетом");
        }

        // Проверяем, что целевой счет принадлежит тому же пользователю
        if (!targetInvoice.getContract().getUser().equals(user)) {
            throw new AccessDeniedException("Целевой счет вам не принадлежит");
        }

        // Проверяем статусы счетов
        if (sourceInvoice.getStatus() != InvoiceStatus.ACTIVE || 
            targetInvoice.getStatus() != InvoiceStatus.ACTIVE) {
            throw new RuntimeException("Один из счетов заморожен или неактивен");
        }

        // Выполняем перевод
        operationService.transferMoney(sourceInvoice, targetInvoice, amount);
        
        redirectAttributes.addFlashAttribute("success", 
            String.format("Успешно переведено %.2f BYN на счет #%d", amount, targetInvoiceId));
        
        return "redirect:/bills/" + id + "/details";
        
    } catch (Exception e) {
        redirectAttributes.addFlashAttribute("error", e.getMessage());
        return "redirect:/bills/" + id + "/details";
    }
}
}