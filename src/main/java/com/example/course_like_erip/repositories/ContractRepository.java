package com.example.course_like_erip.repositories;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.ContractStatus;

public interface ContractRepository extends JpaRepository<Contract, Long> {

  Object findByUserAndStatus(User user, ContractStatus active);
  List<Contract> findByUser(User user);
  
}
