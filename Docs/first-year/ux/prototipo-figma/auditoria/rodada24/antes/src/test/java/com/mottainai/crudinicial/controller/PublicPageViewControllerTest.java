package com.mottainai.crudinicial.controller;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockServletContext;
import org.springframework.core.io.FileSystemResourceLoader;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// NAVEGAÇÃO PÚBLICA E JSP AUSENTE
// Preserva as views públicas da V3 e confere que /login abre o modal da Home na V4, inclusive sob context path.

class PublicPageViewControllerTest {
    @Test
    void publicPagesRemainAvailableAndLoginOpensHomeModal() throws Exception {
        MockMvc mvc = MockMvcBuilders.standaloneSetup(new HomeViewController(),
                new PublicPageViewController(new MockServletContext("src/main/webapp", new FileSystemResourceLoader())))
                .setViewResolvers(new org.springframework.web.servlet.view.InternalResourceViewResolver("/WEB-INF/jsp/", ".jsp"))
                .build();
        mvc.perform(get("/")).andExpect(status().isOk()).andExpect(view().name("home"));
        mvc.perform(get("/home")).andExpect(status().isOk()).andExpect(view().name("home"));
        for (String page : new String[]{"sobre-nos", "planos", "faq"}) {
            mvc.perform(get("/" + page)).andExpect(status().isOk()).andExpect(view().name(page))
                    .andExpect(forwardedUrl("/WEB-INF/jsp/" + page + ".jsp"));
            mvc.perform(get("/mottainai/" + page).contextPath("/mottainai"))
                    .andExpect(status().isOk()).andExpect(view().name(page));
        }
        mvc.perform(get("/login")).andExpect(status().isOk()).andExpect(view().name("home"))
                .andExpect(model().attribute("abrirLogin", true))
                .andExpect(forwardedUrl("/WEB-INF/jsp/home.jsp"));
        mvc.perform(get("/mottainai/login").contextPath("/mottainai"))
                .andExpect(status().isOk()).andExpect(view().name("home"))
                .andExpect(model().attribute("abrirLogin", true));
    }

    // O erro flash e o logout voltam ao mesmo modal; nenhuma credencial é devolvida para preencher a view.
    @Test
    void authenticationFailureAndLogoutReturnToHomeLoginModal() throws Exception {
        var service = org.mockito.Mockito.mock(com.mottainai.crudinicial.security.AdministrationAuthService.class);
        org.mockito.Mockito.when(service.authenticate("admin@example.com", "wrong"))
                .thenReturn(java.util.Optional.empty());
        var mvc = MockMvcBuilders.standaloneSetup(new AuthenticationController(service),
                new PublicPageViewController(new MockServletContext("src/main/webapp", new FileSystemResourceLoader())))
                .setViewResolvers(new org.springframework.web.servlet.view.InternalResourceViewResolver("/WEB-INF/jsp/", ".jsp"))
                .build();
        var failure = mvc.perform(post("/login").param("email", "admin@example.com").param("password", "wrong"))
                .andExpect(redirectedUrl("/login"))
                .andExpect(flash().attribute("erro", "E-mail ou senha inválidos."))
                .andReturn();
        mvc.perform(get("/login").flashAttrs(failure.getFlashMap()))
                .andExpect(view().name("home"))
                .andExpect(model().attribute("abrirLogin", true))
                .andExpect(model().attribute("erro", "E-mail ou senha inválidos."))
                .andExpect(model().attributeDoesNotExist("password", "passwordHash"));
        var session = new org.springframework.mock.web.MockHttpSession();
        session.setAttribute("administrationId", 7);
        mvc.perform(post("/logout").session(session)).andExpect(redirectedUrl("/home"));
        org.junit.jupiter.api.Assertions.assertTrue(session.isInvalid());
        mvc.perform(get("/login")).andExpect(view().name("home"))
                .andExpect(model().attribute("abrirLogin", true));
    }
}
