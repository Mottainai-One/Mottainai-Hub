package com.mottainai.crudinicial.controller;

import com.mottainai.crudinicial.config.WebConfig;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.mock.web.MockServletContext;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// CONTRATO DE SESSÃO E INTERCEPTOR
// Usa WebConfig real e handlers de prova para conferir sessão e liberação dos assets públicos/CRUD da V4 sem PostgreSQL.

class AdministrationSessionTest {
    // CONFIGURAÇÃO LOCAL DO CENÁRIO
    // O Controller de prova separa o teste de proteção de rotas dos fluxos reais de persistência dos CRUDs.
    @Configuration
    @EnableWebMvc
    static class Routes {
        @Bean Probe probe() { return new Probe(); }
        @Bean AuthenticationController authentication() {
            var service = org.mockito.Mockito.mock(com.mottainai.crudinicial.security.AdministrationAuthService.class);
            var admin = new com.mottainai.crudinicial.dto.AdministrationResponseDTO();
            admin.setAdministrationId(7); admin.setEmail("admin@example.com");
            org.mockito.Mockito.when(service.authenticate("admin@example.com", "secret"))
                    .thenReturn(java.util.Optional.of(admin));
            return new AuthenticationController(service);
        }
    }
    // RESPOSTA DE PROVA
    // O handler devolve sucesso para deixar o teste observar apenas a liberação/bloqueio feita pelo interceptor.
    @RestController
    static class Probe {
        @RequestMapping("/**") String page() { return "ok"; }
    }

    @Test
    void realWebConfigurationProtectsCrudAndApisWhilePublicPathsStayFree() throws Exception {
        try (var context = new AnnotationConfigWebApplicationContext()) {
            context.setServletContext(new MockServletContext());
            context.register(WebConfig.class, Routes.class);
            context.refresh();
            var mvc = MockMvcBuilders.webAppContextSetup(context).build();
            var login = mvc.perform(post("/login").param("email", "admin@example.com").param("password", "secret"))
                    .andExpect(redirectedUrl("/inicio")).andReturn();
            var session = (MockHttpSession) login.getRequest().getSession(false);
            for (String route : new String[]{"/inicio", "/empresas", "/lojas", "/enderecos", "/funcionarios",
                    "/cargos", "/contas", "/planos-administrativos", "/administrations",
                    "/api/companies", "/api/stores", "/api/addresses", "/api/employees",
                    "/api/employee-roles", "/api/user-accounts", "/api/subscription-plans", "/api/administrations"}) {
                mvc.perform(get(route)).andExpect(redirectedUrl("/login"));
                mvc.perform(post(route + "/1/delete")).andExpect(redirectedUrl("/login"));
                mvc.perform(get(route).session(session)).andExpect(status().isOk())
                        .andExpect(header().string("Cache-Control", "no-store"));
                mvc.perform(post(route + "/1/update").session(session)).andExpect(status().isOk());
            }
            for (String route : new String[]{"/", "/home", "/sobre-nos", "/planos", "/faq", "/login",
                    "/assets/icons/logo.svg", "/assets/css/crud.css", "/assets/js/crud.js",
                    "/assets/css/home.css", "/assets/js/modais.js", "/resources/test.js"}) {
                mvc.perform(get(route)).andExpect(status().isOk());
            }
            mvc.perform(get("/app/inicio").contextPath("/app")).andExpect(redirectedUrl("/app/login"));
            var wrongSession = new MockHttpSession();
            wrongSession.setAttribute("userId", 7);
            mvc.perform(get("/inicio").session(wrongSession)).andExpect(redirectedUrl("/login"));
            mvc.perform(post("/logout").session(session)).andExpect(redirectedUrl("/login"));
            org.junit.jupiter.api.Assertions.assertTrue(session.isInvalid());
            mvc.perform(get("/inicio")).andExpect(redirectedUrl("/login"));
        }
    }
}
