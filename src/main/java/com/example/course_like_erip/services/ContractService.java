package com.example.course_like_erip.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.ContractStatus;
import com.example.course_like_erip.repositories.ContractRepository;
import com.example.course_like_erip.repositories.InvoiceRepository;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class ContractService {
    private final ContractRepository contractRepository;
    private final InvoiceRepository invoiceRepository;
    public Contract getActiveContractByUser(User user) {
        return (Contract) contractRepository.findByUserAndStatus(user, ContractStatus.ACTIVE);
    }

    public List<Invoice> getBillsByContract(Contract contract) {
        return invoiceRepository.findByContract(contract);
    }

    public List<Contract> getContractsByUser(User user) {
      return contractRepository.findByUser(user);
  }

  public Contract save(Contract contract) {
    return contractRepository.save(contract);
}

}