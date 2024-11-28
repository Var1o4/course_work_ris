package com.example.course_like_erip.models;

import com.example.course_like_erip.models.Enum.OperationType;
import jakarta.persistence.*;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "operations")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Operation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "transaction_id")
    private Long transactionId;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "invoice_id", nullable = false)
    private Invoice bill;
    
    @Column(nullable = false)
    @Positive
    private BigDecimal amount;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false, length = 20)
    private OperationType type;
    
    @Column(name = "recipient_account", nullable = false)
    private String recipientAccount;
    
    @Column(name = "operation_date", nullable = false)
    private LocalDateTime operationDate;
    
    @Column(name = "description")
    private String description;
}