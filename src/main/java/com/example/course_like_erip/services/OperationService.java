package com.example.course_like_erip.services;

import com.example.course_like_erip.models.Enum.OperationType;
import com.example.course_like_erip.repositories.OperationRepository;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Operation;
import com.example.course_like_erip.models.Payment;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@Slf4j
@RequiredArgsConstructor
public class OperationService {
    private final InvoiceService invoiceService;
    private final OperationRepository operationRepository;
    
    @Transactional
    public void processPayment(Payment payment, Invoice sourceInvoice, BigDecimal amount) {
        // Находим главный счет юр.лица
        Invoice mainInvoice = invoiceService.findMainInvoiceByUser(payment.getUser());
        if (mainInvoice == null) {
            throw new RuntimeException("Не найден главный счет для проведения операции");
        }

        // Проверяем достаточность средств
        if (sourceInvoice.getAmount().compareTo(amount) < 0) {
            throw new RuntimeException("Недостаточно средств на счете");
        }

        // Создаем операцию списания со счета пользователя
        Operation withdrawalOp = Operation.builder()
                .bill(sourceInvoice)
                .amount(amount)
                .type(OperationType.WITHDRAWAL)
                .recipientAccount(mainInvoice.getInvoiceId().toString())
                .operationDate(LocalDateTime.now())
                .build();

        // Создаем операцию пополнения главного счета
        Operation depositOp = Operation.builder()
                .bill(mainInvoice)
                .amount(amount)
                .type(OperationType.DEPOSIT)
                .recipientAccount(sourceInvoice.getInvoiceId().toString())
                .operationDate(LocalDateTime.now())
                .build();

        // Обновляем балансы
        sourceInvoice.setAmount(sourceInvoice.getAmount().subtract(amount));
        mainInvoice.setAmount(mainInvoice.getAmount().add(amount));
        
        // Сохраняем операции
        operationRepository.save(withdrawalOp);
        operationRepository.save(depositOp);
    }
}