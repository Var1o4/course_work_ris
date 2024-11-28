package com.example.course_like_erip.services;

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.Enum.ActionType;
import com.example.course_like_erip.models.Enum.ContractStatus;
import com.example.course_like_erip.models.Enum.InvoiceStatus;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.repositories.InvoiceRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class InvoiceService {
    private final InvoiceRepository invoiceRepository;
    private final ContractService contractService;
    private final HistoryService historyService;

    public Invoice createInvoice(Contract contract, BigDecimal amount, boolean isNationalCurrency) {
      if (contract.getStatus() != ContractStatus.ACTIVE) {
          throw new IllegalStateException("Невозможно создать счет для неактивного договора");
      }
  
      Invoice invoice = new Invoice();
      invoice.setContract(contract);
      invoice.setAmount(amount);
      invoice.setNationalCurrency(isNationalCurrency);
      invoice.setStatus(InvoiceStatus.ACTIVE);
      invoice.setCreatedDate(LocalDateTime.now());
      invoice.setMainAccount(false);
      
      return invoiceRepository.save(invoice);
  }

  public Invoice save(Invoice invoice) {
    return invoiceRepository.save(invoice);
}
  
    public List<Invoice> getInvoicesByContract(Contract contract) {
        return invoiceRepository.findByContract(contract);
    }

    public void updateInvoiceStatus(Long id, InvoiceStatus status, HttpServletRequest request) {
        Invoice invoice = getInvoiceById(id);
        String oldStatus = invoice.getStatus().toString();
        invoice.setStatus(status);
        invoiceRepository.save(invoice);
        
        historyService.saveHistory(
            "invoices",
            "Старый статус: " + oldStatus,
            "Новый статус: " + status,
            invoice.getContract().getUser(),
            "status",
            ActionType.STATUS_CHANGE,
            invoice.getInvoiceId(),
            request.getRemoteAddr(),
            request.getHeader("User-Agent")
        );
    }

    public Invoice getInvoiceById(Long id) {
        return invoiceRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Счет не найден"));
    }

      public Invoice findMainInvoiceByUser(User user) {
        return invoiceRepository.findByContractUserAndIsMainAccountTrue(user);
      }

    @Transactional
    public void setMainAccount(Long invoiceId, Contract contract) {
        // Сначала убираем признак главного счета у всех счетов контракта
        List<Invoice> contractInvoices = getInvoicesByContract(contract);
        for (Invoice invoice : contractInvoices) {
            invoice.setMainAccount(false);
            invoiceRepository.save(invoice);
        }

        // Устанавливаем новый главный счет
        Invoice mainInvoice = getInvoiceById(invoiceId);
        mainInvoice.setMainAccount(true);
        invoiceRepository.save(mainInvoice);
    }

    public List<Invoice> getInvoicesByUser(User user) {
        List<Contract> userContracts = contractService.getContractsByUser(user);
        List<Invoice> userInvoices = new ArrayList<>();
        
        for (Contract contract : userContracts) {
            userInvoices.addAll(getInvoicesByContract(contract));
        }
        
        return userInvoices;
    }
  



  public List<Invoice> findActiveInvoicesByUser(User user) {

    // Получаем активный контракт пользователя
    Contract contract = contractService.getActiveContractByUser(user);
    System.out.println("Найден активный контракт для пользователя " + user.getEmail() + ": " + contract);
    if (contract == null) {
        return new ArrayList<>();
    }
    
    // Получаем все активные счета по контракту
    return invoiceRepository.findByContractAndStatus(contract, InvoiceStatus.ACTIVE);
  }
}

