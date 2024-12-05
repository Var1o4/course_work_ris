package com.example.course_like_erip.services;

import com.example.course_like_erip.models.Enum.ActionType;
import com.example.course_like_erip.models.Enum.ContractStatus;
import com.example.course_like_erip.models.Enum.OperationType;
import com.example.course_like_erip.models.Enum.Role;
import com.example.course_like_erip.models.Contract;
import com.example.course_like_erip.models.Invoice;
import com.example.course_like_erip.models.Operation;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.repositories.ContractRepository;
import com.example.course_like_erip.repositories.UserRepository;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.data.repository.CrudRepository;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;
    private final RestTemplateBuilder restTemplateBuilder;
    private final ContractRepository contractRepository;
    private final HistoryService historyService;
    private final ContractService contractService;
    private final InvoiceService invoiceService;
    private final OperationService operationService;



   

    public User getUserByPrincipal(Principal principal) {
        if(principal == null) return new User();
        return userRepository.findByEmail(principal.getName());
    }

    public boolean createUser(User user, HttpServletRequest request) {
      String email = user.getEmail();
      if (userRepository.findByEmail(email) != null) return false;
      
      user.setActive(true);
      
      // Специальная обработка для админа
      if (email.equals("1111@mail.com")) {
          user.setPassword(passwordEncoder.encode("1111"));
          user.getRoles().add(Role.ROLE_ADMIN);
          user.setVerified(true);
          user.setVerificationSubmitted(true);
          user.setAddress("Admin Address");
          user.setPassportNumber("Admin Passport");
      } else {
          user.setPassword(passwordEncoder.encode(user.getPassword()));
          user.getRoles().add(Role.ROLE_USER);
      }
      
      log.info("Saving new User with email: {}", email);
      userRepository.save(user);

      historyService.saveHistory(
        "users",
        null,
        "Регистрация пользователя",
        user,
        "email, roles",
        ActionType.CREATE,
        user.getId(),
        request.getRemoteAddr(),
        request.getHeader("User-Agent")
    );


      return true;
  }

//    public List<News> getNews(Long id){
//        News news = new News();
//        if(newsRepository.findByUser_Id(id)!=null){
//            log.info("Saving new User with email: {}", newsRepository.findByUser_Id(id).size());
//            return newsRepository.findByUser_Id(id);}
//
//        else return null;
//    }

  public List<User> listUsers(){
        return userRepository.findAll();
  }

    public void userBan(Long id){
        User user = userRepository.findById(id).orElse(null);
        if (user != null){
            if(user.isActive()){
                user.setActive(false);
                log.info("Ban user with id = {}; email {}", user.getId(), user.getEmail());

            }
            else {
                log.info("UnBan user with id = {}; email {}", user.getId(), user.getEmail());
                user.setActive(true);
            }
        }
        userRepository.save(user);
    }

    public void changeUserRoles(User user, Map<String, String> form) {
        Set<String> roles = Arrays.stream(Role.values())
                .map(Role::name)
                .collect(Collectors.toSet());
        user.getRoles().clear();
        for(String key : form.keySet()){
            if(roles.contains(key)){
                user.getRoles().add(Role.valueOf(key));
                log.info("User {} set role {}", user.getEmail(), key);
            }
        }

        userRepository.save(user);

    }

    public List<User> getUsersByIds(List<Long> userIds) {
        return userRepository.findAllById(userIds);
    }

    public void saveProfile(Principal principal, User user, MultipartFile file1) throws IOException {

       User userNow = getUserByPrincipal(principal);
        userNow.setEmail(user.getEmail());
        userNow.setPhoneNumber(user.getPhoneNumber());
        userNow.setName(user.getName());
        userNow.setSpeciality(user.getSpeciality());
        userNow.setExpirience(user.getExpirience());

      userRepository.save(userNow);

        }


    public User findById(Long userId) {
    return userRepository.findById(userId).orElse(null);
    }

    public Optional<User> getUsersById(Long userId) {
        return userRepository.findById(userId);
    }

//    public void deleteNews(Long id) {
//        User user = userRepository.findById(id).orElseThrow();
//        Company company = user.getCompany();
//        company.getUsers().remove(user);
//
//        // Устанавливаем связь пользователя с компанией в null
//        user.setCompany(null);
//
//        // Сохраняем изменения в репозитории пользователя
//        userRepository.save(user);
//
//        // Сохраняем изменения в репозитории компании
//        companyRepository.save(company);
//    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }



   public void submitVerification(Principal principal, String address, 
        String passportNumber, MultipartFile personalPhoto, 
        MultipartFile passportPhoto, String userType, int contractDuration) throws IOException {
    
    User user = getUserByPrincipal(principal);
    user.setAddress(address);
    user.setPassportNumber(passportNumber);
    user.setPersonalPhoto(personalPhoto.getBytes());
    user.setPassportPhoto(passportPhoto.getBytes());
    user.setVerificationSubmitted(true);
    
    // Добавляем выбранную роль
    if (userType.equals("ROLE_URFACE")) {
        user.getRoles().add(Role.ROLE_URFACE);
    } else {
        user.getRoles().add(Role.ROLE_USER);
    }
    
    userRepository.save(user);
    
    // Создаем договор
    Contract contract = new Contract();
    contract.setUser(user);
    contract.setContractNumber(generateContractNumber());
    contract.setStartDate(LocalDate.now());
    contract.setEndDate(LocalDate.now().plusYears(contractDuration));
    contract.setStatus(ContractStatus.ACTIVE);
    
    
    contractRepository.save(contract);
}

private String generateContractNumber() {
    return "C-" + LocalDate.now().getYear() + "-" + 
           String.format("%04d", new Random().nextInt(10000));
}
    
    public void processVerification(Long userId, boolean approved, HttpServletRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
                
        if (approved) {
            user.setVerified(true);
            user.getRoles().add(Role.ROLE_USER);
            userRepository.save(user);
        } else {
            userRepository.delete(user);
        }

        historyService.saveHistory(
        "users",
        "Статус верификации: не верифицирован",
        "Статус верификации: " + (approved ? "подтвержден" : "отклонен"),
        user,
        "verified, roles",
        ActionType.VERIFICATION,
        user.getId(),
        request.getRemoteAddr(),
        request.getHeader("User-Agent")
    );
    }
    
    public List<User> getPendingVerifications() {
      log.info("Getting pending verifications");
      
      // Получаем всех пользователей для проверки
      List<User> allUsers = userRepository.findAll();
      log.info("Total users in system: {}", allUsers.size());
      
      // Логируем состояние всех пользователей
      allUsers.forEach(user -> {
          log.info("User {}: verificationSubmitted={}, verified={}", 
                  user.getEmail(),
                  user.isVerificationSubmitted(),
                  user.isVerified());
      });
      
      List<User> pendingUsers = userRepository.findByVerificationSubmittedTrueAndVerifiedFalse();
      log.info("Found {} users pending verification", pendingUsers.size());
      
      pendingUsers.forEach(user -> {
          log.info("Pending user: email={}, verificationSubmitted={}, verified={}", 
                  user.getEmail(), 
                  user.isVerificationSubmitted(), 
                  user.isVerified());
      });
      
      return pendingUsers;
  }
    public User findAdminUser() {
      return userRepository.findByEmail("1111@mail.com");
    }

    public List<User> getUsersByRole(Role role) {
        return userRepository.findByRolesContainingAndVerifiedTrue(role);
    }
    
    public List<User> getAllVerifiedUsers() {
        return userRepository.findByVerifiedTrue();
    }
    
    public User getUserById(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new UsernameNotFoundException("Пользователь не найден"));
    }
    
    public void banUser(Long userId, HttpServletRequest request) {
        User user = getUserById(userId);
        user.setActive(false);
        userRepository.save(user);
        
        historyService.saveHistory(
            "users",
            "Статус: активен",
            "Статус: заблокирован",
            user,
            "active",
            ActionType.BAN,
            userId,
            request.getRemoteAddr(),
            request.getHeader("User-Agent")
        );
    }

    public void toggleUserBan(Long userId, HttpServletRequest request) {
        User user = getUserById(userId);
        user.setActive(!user.isActive());
        userRepository.save(user);
        
        String oldStatus = user.isActive() ? "заблокирован" : "активен";
        String newStatus = user.isActive() ? "активен" : "заблокирован";
        
        historyService.saveHistory(
            "users",
            "Статус: " + oldStatus,
            "Статус: " + newStatus,
            user,
            "active",
            ActionType.BAN,
            userId,
            request.getRemoteAddr(),
            request.getHeader("User-Agent")
        );
    }


    public List<Map<String, Object>> getSuspiciousUsers() {
        List<Map<String, Object>> suspiciousUsers = new ArrayList<>();
        List<User> users = getAllVerifiedUsers();
        
        for (User user : users) {
            List<Contract> contracts = contractService.getContractsByUser(user);
            
            for (Contract contract : contracts) {
                List<Invoice> invoices = invoiceService.getInvoicesByContract(contract);
                
                for (Invoice invoice : invoices) {
                    List<Operation> operations = operationService.getOperationsByBill(invoice);
                    
                    // Считаем уникальных отправителей
                    long uniqueSenders = operations.stream()
                        .filter(op -> op.getType() == OperationType.TRANSFER_IN)
                        .map(Operation::getRecipientAccount)
                        .filter(account -> account != null && !account.isEmpty())
                        .distinct()
                        .count();
                    
                    if (uniqueSenders > 100) {
                        Map<String, Object> suspiciousUser = new HashMap<>();
                        suspiciousUser.put("user", user);
                        suspiciousUser.put("invoice", invoice);
                        suspiciousUser.put("sendersCount", uniqueSenders);
                        suspiciousUsers.add(suspiciousUser);
                    }
                }
            }
        }
        return suspiciousUsers;
    }
}
