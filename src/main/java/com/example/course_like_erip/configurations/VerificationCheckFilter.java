package com.example.course_like_erip.configurations;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.Role;
import com.example.course_like_erip.services.UserService;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class VerificationCheckFilter extends OncePerRequestFilter {
    @Autowired
    private UserService userService;
    @Override
    protected void doFilterInternal(HttpServletRequest request,
            HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
            
        String path = request.getRequestURI();
        
        if (isAllowedPath(path)) {
            filterChain.doFilter(request, response);
            return;
        }
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken)) {
            User user = userService.findByEmail(auth.getName());
            
            if (user != null) {
                if (user.getEmail().equals("1111@mail.com") || 
                    user.getRoles().contains(Role.ROLE_ADMIN)) {
                    filterChain.doFilter(request, response);
                    return;
                }
                
                if (user.isBanned() && !path.equals("/banned")) {
                    response.sendRedirect("/banned");
                    return;
                }
                
                   // Если пользователь не верифицирован
                   if (!user.isVerified()) {
                    // Если форма верификации не заполнена, отправляем на форму
                    if (!user.isVerificationSubmitted()) {
                        if (path.equals("/verify")) {
                            filterChain.doFilter(request, response);
                            return;
                        }
                        response.sendRedirect("/verify");
                        return;
                    }
                    // Если форма заполнена, но верификация не пройдена
                    if (path.equals("/verification-pending")) {
                        filterChain.doFilter(request, response);
                        return;
                    }
                    response.sendRedirect("/verification-pending");
                    return;
                }
            }
        }
        
        filterChain.doFilter(request, response);
    }
    
    private boolean isAllowedPath(String path) {
        return path.equals("/") || 
               path.startsWith("/static") || 
               path.equals("/logout") ||
               path.equals("/login") || 
               path.equals("/registration") ||
               path.equals("/css/style.css") ||
               path.matches(".+\\.(js|css|png|jpg|jpeg|gif|ico|woff|woff2|ttf|eot|svg)$");
    }
}
