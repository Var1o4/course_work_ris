package com.example.course_like_erip.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.course_like_erip.models.Notification;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.NotificationStatus;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByRecipientOrderByCreatedAtDesc(User recipient);
    List<Notification> findByRecipientAndStatusOrderByCreatedAtDesc(User recipient, NotificationStatus status);
    long countByRecipientAndStatus(User recipient, NotificationStatus status);
} 