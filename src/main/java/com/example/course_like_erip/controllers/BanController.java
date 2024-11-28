package com.example.course_like_erip.controllers;

import com.example.course_like_erip.models.User;
import com.example.course_like_erip.services.UserService;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;


@Controller
@RequiredArgsConstructor
public class BanController {

    private final UserService userService;
    @GetMapping("/banned")
    public String getBannedPage(Principal principal, Model model) {
        if (principal != null) {
            User user = userService.findByEmail(principal.getName());
            model.addAttribute("user", user);
        }
        return "banned";
    }
}