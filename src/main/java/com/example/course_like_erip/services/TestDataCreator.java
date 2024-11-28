package com.example.course_like_erip.services;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Operation;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.ContractStatus;
import com.example.course_like_erip.models.Enum.InvoiceStatus;
import com.example.course_like_erip.models.Enum.OperationType;
import com.example.course_like_erip.models.Enum.Role;
import com.example.course_like_erip.repositories.UserRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Set;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Arrays;

@Service
@RequiredArgsConstructor
public class TestDataCreator {
    private final UserService userService;
    private final UserRepository userRepository;
    private final ContractService contractService;
    private final InvoiceService invoiceService;
    private final OperationService operationService;
    
    @Transactional
    public void createSuspiciousUserTestData() {
        // Создаем пользователя
        User user = User.builder()
                .name("suspicious_user")
                .password("password123")
                .email("suspicious@test.com")
                .roles(new HashSet<>(Arrays.asList(Role.ROLE_USER)))
                .verified(true)
                .active(true)
                .build();
        userRepository.save(user);
        
        // Создаем контракт
        Contract contract = Contract.builder()
                .user(user)
                .status(ContractStatus.ACTIVE)
                .contractNumber("TEST-" + System.currentTimeMillis())
                .startDate(LocalDate.now())
                .endDate(LocalDate.now().plusYears(1))
                .build();
        contractService.save(contract);
        
        // Создаем счет
        Invoice invoice = Invoice.builder()
                .contract(contract)
                .amount(new BigDecimal("10000.00"))
                .status(InvoiceStatus.ACTIVE)
                .createdDate(LocalDateTime.now())
                .isNationalCurrency(true)
                .isMainAccount(false)
                .build();
        invoiceService.save(invoice);
        
        // Создаем 150 операций от разных отправителей
        for (int i = 1; i <= 150; i++) {
            Operation operation = Operation.builder()
                    .bill(invoice)
                    .amount(new BigDecimal("100.00"))
                    .type(OperationType.TRANSFER_IN)
                    .recipientAccount("SENDER_" + i)
                    .operationDate(LocalDateTime.now().minusDays(i))
                    .description("Тестовый перевод от отправителя " + i)
                    .build();
            operationService.save(operation);
        }
    }
} 