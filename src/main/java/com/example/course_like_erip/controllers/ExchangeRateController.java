package com.example.course_like_erip.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/exchange-rates")
public class ExchangeRateController {
    
    @GetMapping("/chart")
    public String getExchangeRateChart() {
        return "exchange/chart";
    }
} 