package com.example.course_like_erip.repositories;

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.Enum.InvoiceStatus;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    List<Invoice> findByContract(Contract contract);
    List<Invoice> findByContractAndStatus(Contract contract, InvoiceStatus status);
    Optional<Invoice> findByInvoiceIdAndContract(Long invoiceId, Contract contract);
    Invoice findByContractUserAndIsMainAccountTrue(User user);
}