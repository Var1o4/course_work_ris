package com.example.course_like_erip.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long id;
    
    @Column(name = "name")
    private String name;
    
    @Column(name = "description")
    private String description;
    
    @Column(name = "amount")
    private Double amount;
    
    @Column(name = "status")
    private String status;
    
    @Column(name = "is_group")
    private boolean group;
    
    @Column(name = "fixed_price")
    private boolean fixedPrice;
    
    @ToString.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_payment_id")
    private Payment parentPayment;
    
    @ToString.Exclude
    @OneToMany(mappedBy = "parentPayment", cascade = CascadeType.ALL)
    private List<Payment> childPayments = new ArrayList<>();
    
    @ToString.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
    
    @Column(name = "payment_due_date")
    private LocalDateTime paymentDueDate;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipient_id")
    private User recipient;
} 