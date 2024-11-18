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

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.ContractStatus;
import com.example.course_like_erip.services.ContractService;
import com.example.course_like_erip.services.UserService;
import com.example.course_like_erip.services.InvoiceService;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Enum.InvoiceStatus;

import lombok.RequiredArgsConstructor;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.AccessDeniedException;
import java.security.Principal;
import javax.security.auth.login.AccountException;

@Controller
@RequiredArgsConstructor
@RequestMapping("/bills")
public class BillController {
    private final UserService userService;
    private final ContractService contractService;
    private final InvoiceService invoiceService;

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
    @PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE')")
    public String freezeBill(@PathVariable Long id, Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        Invoice invoice = invoiceService.getInvoiceById(id);
        if (!invoice.getContract().getUser().equals(user)) {
            throw new org.springframework.security.access.AccessDeniedException("У вас нет прав на управление этим счетом");
        }
        
        invoiceService.updateInvoiceStatus(id, InvoiceStatus.FROZEN);
        return "redirect:/bills";
    }

    @GetMapping("/{id}/details")
@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE')")
public String getBillDetails(@PathVariable Long id, Principal principal, Model model) {
    User user = userService.getUserByPrincipal(principal);
    Invoice invoice = invoiceService.getInvoiceById(id);
    if (!invoice.getContract().getUser().equals(user)) {
        throw new org.springframework.security.access.AccessDeniedException("У вас нет прав на просмотр этого счета");
    }
    
    model.addAttribute("bill", invoice);
    return "bills/bill-details";
}

@PostMapping("/{id}/set-main")
@PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE')")
public String setMainAccount(@PathVariable Long id, Principal principal) {
    User user = userService.getUserByPrincipal(principal);
    Invoice invoice = invoiceService.getInvoiceById(id);
    if (!invoice.getContract().getUser().equals(user)) {
        throw new org.springframework.security.access.AccessDeniedException("У вас нет прав на управление этим счетом");
    }
    
    invoiceService.setMainAccount(id, invoice.getContract());
    return "redirect:/bills";
}
}