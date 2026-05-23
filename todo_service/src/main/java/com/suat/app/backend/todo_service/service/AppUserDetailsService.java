package com.suat.app.backend.todo_service.service;

import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class AppUserDetailsService implements UserDetailsService {

    @Autowired
    private AppUserRepository appUserRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 1. 从我们的数据库中查找用户
        AppUser appUser = appUserRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));

        // 2. 将我们的 AppUser 实体 转换为 Spring Security 认识的 UserDetails
        //    (我们暂时不处理角色 'roles'，所以给一个空列表)
        return new User(appUser.getUsername(), appUser.getPassword(), Collections.emptyList());
    }
}