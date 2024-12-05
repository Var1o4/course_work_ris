package com.example.course_like_erip.controllers;


import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.course_like_erip.models.Notification;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.services.NotificationService;
import com.example.course_like_erip.services.UserService;

import lombok.extern.slf4j.Slf4j;
import lombok.RequiredArgsConstructor;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/debts")
@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_USER')")
@Slf4j
@RequiredArgsConstructor
public class DebtController {

    private final NotificationService notificationService;
    private final UserService userService;

    @GetMapping
    public String getDebts(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        List<Notification> notifications = notificationService.getNotificationsByUser(user);
        
        log.info("Получен список уведомлений для пользователя {}: {}", user.getEmail(), notifications);
        log.info("Размер списка уведомлений: {}", notifications.size());
        log.info("Первое уведомление: {}", notifications.isEmpty() ? "нет" : notifications.get(0));
        
        model.addAttribute("notifications", notifications);
        model.addAttribute("user", user);
        return "debts/debts";
    }
} 