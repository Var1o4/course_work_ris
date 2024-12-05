package com.example.course_like_erip.models;


import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.example.course_like_erip.models.Enum.InvoiceStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity
@Table(name = "invoices")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long invoiceId;

    @ManyToOne
    @JoinColumn(name = "contract_id", nullable = false)
    private Contract contract;

    @Column(nullable = false)
    private LocalDateTime createdDate;

    private LocalDateTime closeDate;

    @Column(nullable = false)
    @Positive
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private InvoiceStatus status;

    @Column(nullable = false)
    private boolean isNationalCurrency;

    @Column(name = "is_main_account", nullable = false)
    private boolean isMainAccount = false;

    @PrePersist
public void prePersist() {
    if (createdDate == null) {
        createdDate = LocalDateTime.now();
    }
    if (status == null) {
        status = InvoiceStatus.ACTIVE;
    }
    isMainAccount = false;
}

  
}