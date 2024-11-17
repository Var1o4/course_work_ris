package com.example.course_like_erip.repositories;

import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByParentPaymentIsNull();
    List<Payment> findByParentPayment(Payment parentPayment);
    List<Payment> findByUser(User user);
} 