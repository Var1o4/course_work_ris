package com.example.course_like_erip.services;

import com.example.course_like_erip.models.Enum.Role;
import com.example.course_like_erip.models.User;
import com.example.course_like_erip.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;
    private final RestTemplateBuilder restTemplateBuilder;


    public User getUserByPrincipal(Principal principal) {
        if(principal == null) return new User();
        return userRepository.findByEmail(principal.getName());
    }

    public boolean createUser(User user){
        String email = user.getEmail();
        if(userRepository.findByEmail(email)!=null) return false;
        user.setActive(true);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.getRoles().add(Role.ROLE_ADMIN);
        log.info("Saving new User with email: {}", email);
        userRepository.save(user);
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
}
