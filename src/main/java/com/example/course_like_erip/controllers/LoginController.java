package com.example.course_like_erip.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @PostMapping("/login")
    public String login2() {  
        return "redirect:/payment-system";
    }

    @GetMapping("/registration")
    public String registration(){
        return "registration";
    }
}
