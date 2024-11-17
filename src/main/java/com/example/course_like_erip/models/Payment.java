package com.example.course_like_erip.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "payments")
@Data
@AllArgsConstructor
@NoArgsConstructor
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
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_payment_id")
    private Payment parentPayment;
    
    @OneToMany(mappedBy = "parentPayment", cascade = CascadeType.ALL)
    private List<Payment> childPayments = new ArrayList<>();
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

} 