package com.example.course_like_erip.configurations;

import com.example.course_like_erip.services.CustomerUserDetailService;
import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;


@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final CustomerUserDetailService userDetailsService;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    private VerificationCheckFilter verificationCheckFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests((requests) -> requests
                .requestMatchers("/registration", "/login", "/css/**", "/js/**", "/admin/**").permitAll()
                .requestMatchers("/services/**").hasAnyAuthority("ROLE_URFACE", "ROLE_ADMIN")
                .anyRequest().authenticated()
            )
            .formLogin((form) -> form
                .loginPage("/login")
                .defaultSuccessUrl("/")
                .permitAll()
            )
            .logout((logout) -> logout
                .logoutSuccessUrl("/login")
                .permitAll())
            .addFilterAfter(verificationCheckFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public org.springframework.security.authentication.dao.DaoAuthenticationProvider authenticationProvider() {
        org.springframework.security.authentication.dao.DaoAuthenticationProvider authProvider = 
            new org.springframework.security.authentication.dao.DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder);
        return authProvider;
    }

}