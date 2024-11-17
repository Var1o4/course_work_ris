package com.example.course_like_erip.controllers;

import com.example.course_like_erip.models.User;
import com.example.course_like_erip.services.UserService;
import lombok.RequiredArgsConstructor;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;

@Controller
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;






    @PostMapping("/registration")
    public String createUser(User user, Model model){
        if(!userService.createUser(user)){
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
    public String getProfile(Principal principal, Model model)
    {
        User user = userService.getUserByPrincipal(principal);
        model.addAttribute("user", user);
        return "profile";
    }

    @GetMapping("/")
    public String getProfil(Principal principal, Model model)
    {
        User user = userService.getUserByPrincipal(principal);
        model.addAttribute("user", user);
        return "payment-system";
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
    public String submitVerification(
            @RequestParam("address") String address,
            @RequestParam("passportNumber") String passportNumber,
            @RequestParam("personalPhoto") MultipartFile personalPhoto,
            @RequestParam("passportPhoto") MultipartFile passportPhoto,
            Principal principal) throws IOException {
            
        userService.submitVerification(principal, address, passportNumber, 
                                     personalPhoto, passportPhoto);
        return "redirect:/verification-pending";
    }
    
    @GetMapping("/admin/verifications")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String pendingVerifications(Model model) {
        model.addAttribute("pendingUsers", userService.getPendingVerifications());
        return "admin/pending-verifications";  // Убрать лишний admin/ из пути
    }
    
    @PostMapping("/admin/verify/{userId}")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String verifyUser(@PathVariable Long userId, @RequestParam boolean approved) {
        userService.processVerification(userId, approved);
        return "redirect:/admin/verifications";
    }

    @GetMapping("/verification-pending")
public String verificationPending() {
    return "verification-pending";
}
}
