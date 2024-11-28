package com.example.course_like_erip.repositories;

import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByParentPaymentIsNull();
    List<Payment> findByParentPayment(Payment parentPayment);
    List<Payment> findByUser(User user);
    Payment findByNameAndGroupTrue(String name);
    @Query("SELECT p FROM Payment p WHERE p.user.id = :userId OR p.recipient.id = :userId")
    List<Payment> findByUserOrRecipient(@Param("userId") Long userId);
} 