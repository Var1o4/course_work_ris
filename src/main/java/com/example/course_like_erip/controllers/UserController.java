package com.example.course_like_erip.controllers;

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.ExchangeRate;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.RefinancingRate;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.ContractStatus;
import com.example.course_like_erip.services.ContractService;
import com.example.course_like_erip.services.InvoiceService;
import com.example.course_like_erip.services.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequiredArgsConstructor
@Slf4j
public class UserController {
    private final UserService userService;
    private final RestTemplate restTemplate;
    private final ContractService contractService;
    private final InvoiceService invoiceService;






    @PostMapping("/registration")
    public String createUser(User user, Model model, HttpServletRequest request) {
        if(!userService.createUser(user, request)) {
            model.addAttribute("errorMessage", "Пользователь с email: " + user.getEmail() + " уже существует.");
            return "registration";
        }
        return "redirect:/login";
    }



    @GetMapping("/hello")
    public String securityUrl(){

        return "user-company";
    }

    @GetMapping("/profile-news")
    public String userInfo(Principal principal, Model model){
        User user = userService.getUserByPrincipal(principal);
        model.addAttribute("user", user);
        return "profile-news";
    }



    @GetMapping("/profile")
    @PreAuthorize("isAuthenticated()")
    public String getProfile(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        
        // Получаем все счета пользователя
        List<Contract> contracts = contractService.getContractsByUser(user);
        List<Invoice> userInvoices = new ArrayList<>();
        Contract activeContract = null;
        
        for (Contract contract : contracts) {
            if (contract.getStatus() == ContractStatus.ACTIVE) {
                activeContract = contract;
            }
            userInvoices.addAll(invoiceService.getInvoicesByContract(contract));
        }
        
        // Находим основной счёт
        Invoice mainInvoice = userInvoices.stream()
            .filter(Invoice::isMainAccount)
            .findFirst()
            .orElse(null);
        
        model.addAttribute("user", user);
        model.addAttribute("userInvoices", userInvoices);
        model.addAttribute("mainInvoice", mainInvoice);
        model.addAttribute("contract", activeContract);
        
        return "profile";
    }

   


    @GetMapping("/profile/edit")
    public String getProfileEdit(Principal principal, Model model)
    {

        User user = userService.getUserByPrincipal(principal);
        model.addAttribute("user", user);

        return "profile-edit";
    }


    @PostMapping("/updateProfile")
    public String redactProfile(@RequestParam("avatar1") MultipartFile avatar1,
                                User user, Principal principal) throws IOException {
        userService.saveProfile(principal, user, avatar1);
        return "redirect:/news";
    }


    @PostMapping("/user-delete{id}")
    public String deleteNews(@PathVariable Long id) {
        return "redirect:/my-company";

    }

      @GetMapping("/verify")
    public String verificationForm(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        if (user.isVerificationSubmitted()) {
            return "redirect:/verification-pending";
        }
        return "verification-form";
    }
    
    @PostMapping("/verify")
public String submitVerification(@RequestParam String address,
        @RequestParam String passportNumber,
        @RequestParam MultipartFile personalPhoto,
        @RequestParam MultipartFile passportPhoto,
        @RequestParam String userType,
        @RequestParam int contractDuration,
        Principal principal) throws IOException {
    
    userService.submitVerification(principal, address, passportNumber,
            personalPhoto, passportPhoto, userType, contractDuration);
    return "redirect:/verification-pending";
}
    
@GetMapping("/admin/verifications")
@PreAuthorize("hasRole('ROLE_ADMIN')")
public String pendingVerifications(Model model, Principal principal) {
    log.info("Admin {} accessing pending verifications", principal.getName());
    
    List<User> pendingUsers = userService.getPendingVerifications();
    log.info("Retrieved {} pending verifications", pendingUsers.size());
    
    model.addAttribute("pendingUsers", pendingUsers);
    return "admin/pending-verifications";
}
    
    @PostMapping("/admin/verify/{userId}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String verifyUser(@PathVariable Long userId, @RequestParam boolean approved, HttpServletRequest request) {
        userService.processVerification(userId, approved, request);
        return "redirect:/admin/verifications";
    }

    @GetMapping("/verification-pending")
    public String verificationPending(Principal principal, Model model) {
        if (principal == null) {
            return "redirect:/login";
        }
        
        User user = userService.getUserByPrincipal(principal);
        if (user.isVerified()) {
            return "redirect:/";
        }
        
        return "verification-pending";
    }

    @GetMapping("/")
    public String home(Model model) {
        try {
            // Получаем курс USD по коду валюты
            String usdUrl = "https://api.nbrb.by/exrates/rates/USD?parammode=2";
            ExchangeRate usdRate = restTemplate.getForObject(usdUrl, ExchangeRate.class);
            log.info("Загружен курс USD: {}", usdRate);
            
            // Получаем курс EUR по коду валюты
            String eurUrl = "https://api.nbrb.by/exrates/rates/EUR?parammode=2";
            ExchangeRate eurRate = restTemplate.getForObject(eurUrl, ExchangeRate.class);
            log.info("Загружен курс EUR: {}", eurRate);
            
            // Получаем ставку рефинансирования (последнюю)
            String refinancingUrl = "https://api.nbrb.by/refinancingrate?ondate=" + 
                LocalDate.now().format(DateTimeFormatter.ISO_DATE);
            RefinancingRate[] refinancingRates = restTemplate.getForObject(refinancingUrl, RefinancingRate[].class);
            
            RefinancingRate refinancingRate = null;
            if (refinancingRates != null && refinancingRates.length > 0) {
                refinancingRate = refinancingRates[0];
                log.info("Загружена ставка рефинансирования: {}", refinancingRate);
            }
            
            if (usdRate != null && eurRate != null && refinancingRate != null) {
                model.addAttribute("usdRate", usdRate);
                model.addAttribute("eurRate", eurRate);
                model.addAttribute("refinancingRate", refinancingRate);
            } else {
                throw new RuntimeException("Не удалось загрузить данные о курсах валют");
            }
            
        } catch (Exception e) {
            log.error("Ошибка при получении курсов валют: ", e);
            model.addAttribute("error", "Сервис курсов валют временно недоступен");
        }
        
        return "payment-system";
    }

    @GetMapping("/user/photo/{userId}/{type}")
    public void getUserPhoto(@PathVariable Long userId, 
                            @PathVariable String type,
                            HttpServletResponse response) throws IOException {
        User user = userService.getUserById(userId);
        byte[] photoData = null;
        
        if ("personal".equals(type)) {
            photoData = user.getPersonalPhoto();
        } else if ("passport".equals(type)) {
            photoData = user.getPassportPhoto();
        }
        
        if (photoData != null && photoData.length > 0) {
            response.setContentType("image/jpeg");
            response.getOutputStream().write(photoData);
        }
    }
}
