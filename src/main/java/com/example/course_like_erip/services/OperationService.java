package com.example.course_like_erip.services;

import com.example.course_like_erip.models.Enum.ActionType;
import com.example.course_like_erip.models.Enum.OperationType;
import com.example.course_like_erip.repositories.InvoiceRepository;
import com.example.course_like_erip.repositories.OperationRepository;
import com.example.course_like_erip.dto.MonthlyExpenseDTO;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Operation;
import com.example.course_like_erip.models.Payment;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.math.BigDecimal;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class OperationService {
    private final InvoiceService invoiceService;
    private final OperationRepository operationRepository;
    private final InvoiceRepository invoiceRepository;
    private final HistoryService historyService;

    
    public Operation save(Operation operation) {
      return operationRepository.save(operation);
  }
  
    @Transactional
    public void processPayment(Payment payment, Invoice sourceInvoice, BigDecimal amount, HttpServletRequest request) {
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
         historyService.saveHistory(
        "operations",
        "Баланс отправителя: " + sourceInvoice.getAmount(),
        "Выполнен перевод на сумму: " + amount,
        payment.getUser(),
        "amount, sourceInvoice, targetInvoice",
        ActionType.TRANSFER,
        withdrawalOp.getTransactionId(),
        request.getRemoteAddr(),
        request.getHeader("User-Agent")
    );
        // Сохраняем операции
        operationRepository.save(withdrawalOp);
        operationRepository.save(depositOp);
    }

    @Transactional
    public void transferMoney(Invoice sourceInvoice, Invoice targetInvoice, BigDecimal amount) {

      System.out.println("sourceInvoice: " + sourceInvoice);
      System.out.println("targetInvoice: " + targetInvoice);
      System.out.println("amount: " + amount);
        // Проверяем корректность суммы
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Сумма перевода должна быть больше нуля");
        }

        // Проверяем достаточность средств
        if (sourceInvoice.getAmount().compareTo(amount) < 0) {
            throw new RuntimeException("Недостаточно средств на счете");
        }

        // Обновляем балансы сначала
        sourceInvoice.setAmount(sourceInvoice.getAmount().subtract(amount));
        targetInvoice.setAmount(targetInvoice.getAmount().add(amount));
        
        // Сохраняем обновленные счета
        sourceInvoice = invoiceRepository.save(sourceInvoice);
        targetInvoice = invoiceRepository.save(targetInvoice);

        // Создаем и сохраняем операцию списания
        Operation withdrawalOp = Operation.builder()
                .bill(sourceInvoice)
                .amount(amount)
                .type(OperationType.TRANSFER_OUT)
                .recipientAccount(targetInvoice.getInvoiceId().toString())
                .operationDate(LocalDateTime.now())
                .description("Перевод на счет #" + targetInvoice.getInvoiceId())
                .build();
        operationRepository.save(withdrawalOp);

        // Создаем и сохраняем операцию пополнения
        Operation depositOp = Operation.builder()
                .bill(targetInvoice)
                .amount(amount)
                .type(OperationType.TRANSFER_IN)
                .recipientAccount(sourceInvoice.getInvoiceId().toString())
                .operationDate(LocalDateTime.now())
                .description("Перевод со счета #" + sourceInvoice.getInvoiceId())
                .build();
        operationRepository.save(depositOp);
    }

  

    public List<Operation> getOperationsByBill(Invoice bill) {
      return operationRepository.findByBillOrderByOperationDateDesc(bill);
  }



    public List<MonthlyExpenseDTO> getMonthlyExpenses(List<Operation> operations, int monthsCount) {
        log.info("Starting getMonthlyExpenses calculation for {} operations, months count: {}", 
                operations.size(), monthsCount);
        
        Map<YearMonth, BigDecimal> expensesByMonth = new TreeMap<>();
        YearMonth currentMonth = YearMonth.now();
        
        // Логируем начальный и конечный месяц
        YearMonth startMonth = currentMonth.minusMonths(monthsCount - 1);
        log.info("Calculating expenses from {} to {}", startMonth, currentMonth);
        
        // Инициализируем месяцы
        for (int i = monthsCount - 1; i >= 0; i--) {
            YearMonth month = currentMonth.minusMonths(i);
            expensesByMonth.put(month, BigDecimal.ZERO);
        }
        
        // Логируем операции расходов
        operations.stream()
            .filter(op -> op.getType() == OperationType.TRANSFER_OUT || op.getType() == OperationType.WITHDRAWAL)
            .forEach(op -> {
                YearMonth operationMonth = YearMonth.from(op.getOperationDate());
                log.debug("Processing operation: date={}, type={}, amount={}", 
                        op.getOperationDate(), op.getType(), op.getAmount());
                
                if (expensesByMonth.containsKey(operationMonth)) {
                    BigDecimal currentAmount = expensesByMonth.get(operationMonth);
                    expensesByMonth.put(operationMonth, currentAmount.add(op.getAmount().abs()));
                }
            });
        
        // Логируем итоговые суммы по месяцам
        expensesByMonth.forEach((month, amount) -> 
            log.info("Month: {}, Total expenses: {}", month, amount));
            
        List<MonthlyExpenseDTO> result = expensesByMonth.entrySet().stream()
            .map(entry -> new MonthlyExpenseDTO(
                entry.getKey().toString(),
                entry.getValue(),
                entry.getKey().format(DateTimeFormatter.ofPattern("LLLL yyyy", new Locale("ru")))
            ))
            .collect(Collectors.toList());
            
        log.info("Final MonthlyExpenseDTO list size: {}", result.size());
        result.forEach(dto -> 
            log.info("DTO: month={}, formattedMonth={}, amount={}", 
                    dto.getMonth(), dto.getFormattedMonth(), dto.getAmount()));
            
        return result;
    }

   
}