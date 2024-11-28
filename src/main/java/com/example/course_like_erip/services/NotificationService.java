package com.example.course_like_erip.services;

import com.example.course_like_erip.models.Enum.NotificationStatus;
import com.example.course_like_erip.models.Notification;
import com.example.course_like_erip.models.Payment;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.repositories.NotificationRepository;
import com.example.course_like_erip.services.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationService {
    private final NotificationRepository notificationRepository;
    private final UserService userService;

    public void createPaymentDueNotification(Payment payment) {
        if (payment.getPaymentDueDate() != null) {
            Notification notification = Notification.builder()
                .sender(userService.findAdminUser())
                .recipient(payment.getUser())
                .message("Напоминание: срок оплаты платежа '" + payment.getName() + 
                        "' истекает " + payment.getPaymentDueDate())
                .status(NotificationStatus.UNREAD)
                .build();
            notificationRepository.save(notification);
        }
    }

    public void createAdminNotification(User recipient, String message) {
        Notification notification = Notification.builder()
                .sender(userService.findAdminUser())
                .recipient(recipient)
                .message(message)
                .status(NotificationStatus.UNREAD)
                .build();
        notificationRepository.save(notification);
    }

    public List<Notification> getUserNotifications(User user) {
        return notificationRepository.findByRecipientOrderByCreatedAtDesc(user);
    }

    public void markAsRead(Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() -> new RuntimeException("Уведомление не найдено"));
        notification.setStatus(NotificationStatus.READ);
        notificationRepository.save(notification);
    }

    public List<Notification> getNotificationsByUser(User user) {
        return notificationRepository.findByRecipientOrderByCreatedAtDesc(user);
    }
} 