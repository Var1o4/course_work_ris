package com.example.course_like_erip.controllers;

import com.example.course_like_erip.models.User;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.example.course_like_erip.models.History;
import com.example.course_like_erip.services.HistoryService;
import com.example.course_like_erip.services.UserService;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/history")
@RequiredArgsConstructor
public class HistoryController {
    private final HistoryService historyService;
    private final UserService userService;

    @GetMapping
    @PreAuthorize("hasAnyRole('ROLE_USER', 'ROLE_URFACE')")
    public String getHistory(@RequestParam(required = false, defaultValue = "all") String period,
                            Model model, Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        LocalDateTime startDate = switch (period) {
            case "day" -> LocalDateTime.now().minusDays(1);
            case "week" -> LocalDateTime.now().minusWeeks(1);
            default -> null;
        };
        
        List<History> histories = historyService.getHistoryByPeriod(user, startDate);
        
        model.addAttribute("histories", histories);
        model.addAttribute("period", period);
        model.addAttribute("user", user);
        return "history/history-list";
    }
} 