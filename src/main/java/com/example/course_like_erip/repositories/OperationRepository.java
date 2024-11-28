package com.example.course_like_erip.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Operation;
import java.util.List;

@Repository
public interface OperationRepository extends JpaRepository<Operation, Long> {
    List<Operation> findByBillOrderByOperationDateDesc(Invoice bill);
    List<Operation> findByBill(Invoice bill);
}
