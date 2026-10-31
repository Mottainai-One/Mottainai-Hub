package com.mottainai.crudinicial.controller;

import com.mottainai.crudinicial.dto.AdministrationResponseDTO;
import com.mottainai.crudinicial.security.AdministrationAuthService;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import java.util.Collections;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// CONTRATO HTTP DE LOGIN E LOGOUT
// Simula o Service para conferir sessão mínima, redirects e mensagens sem expor senha/hash ou erro técnico.

class AuthenticationControllerTest {
    @Test
    void logoutInvalidatesSessionAndIsSafeWithoutSession() throws Exception {
        var mvc = MockMvcBuilders.standaloneSetup(new AuthenticationController(mock(AdministrationAuthService.class)))
                .build();
        var session = new MockHttpSession();
        session.setAttribute("administrationId", 7);
        session.setAttribute("administrationEmail", "admin@example.com");
        mvc.perform(post("/logout").session(session)).andExpect(redirectedUrl("/login"));
        assertTrue(session.isInvalid());
        mvc.perform(post("/logout")).andExpect(redirectedUrl("/login"));
        mvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get("/logout"))
                .andExpect(status().isMethodNotAllowed());
    }

    @Test
    void databaseFailureReturnsFriendlyMessageWithoutTechnicalDetails() throws Exception {
        var service = mock(AdministrationAuthService.class);
        when(service.authenticate(any(), any())).thenThrow(new org.springframework.dao.DataAccessResourceFailureException("SQL confidential"));
        var mvc = MockMvcBuilders.standaloneSetup(new AuthenticationController(service)).build();
        var result = mvc.perform(post("/login").param("email", "admin@example.com").param("password", "secret"))
                .andExpect(redirectedUrl("/login")).andReturn();
        assertFalse(result.getFlashMap().toString().contains("confidential"));
        assertNotNull(result.getFlashMap().get("erro"));
    }

    @Test
    void successfulLoginReplacesSessionAndStoresOnlyIdAndEmail() throws Exception {
        var service = mock(AdministrationAuthService.class);
        var admin = new AdministrationResponseDTO();
        admin.setAdministrationId(7);
        admin.setEmail("admin@example.com");
        when(service.authenticate("admin@example.com", "secret")).thenReturn(Optional.of(admin));
        var mvc = MockMvcBuilders.standaloneSetup(new AuthenticationController(service)).build();
        var oldSession = new MockHttpSession();
        oldSession.setAttribute("oldData", "discard");
        var result = mvc.perform(post("/login").session(oldSession)
                        .param("email", "admin@example.com").param("password", "secret"))
                .andExpect(redirectedUrl("/inicio")).andReturn();
        assertTrue(oldSession.isInvalid());
        var session = result.getRequest().getSession(false);
        assertNotNull(session);
        assertEquals(7, session.getAttribute("administrationId"));
        assertEquals("admin@example.com", session.getAttribute("administrationEmail"));
        assertEquals(2, Collections.list(session.getAttributeNames()).size());
        assertFalse(result.getResponse().getContentAsString().contains("secret"));
    }

    @Test
    void invalidCredentialsNeverCreateAdministrativeSession() throws Exception {
        var service = mock(AdministrationAuthService.class);
        when(service.authenticate(any(), any())).thenReturn(Optional.empty());
        var mvc = MockMvcBuilders.standaloneSetup(new AuthenticationController(service)).build();
        for (String email : new String[]{"missing@example.com", "admin@example.com"}) {
            var result = mvc.perform(post("/login").param("email", email).param("password", "wrong"))
                    .andExpect(redirectedUrl("/login"))
                    .andExpect(flash().attribute("erro", "E-mail ou senha inválidos."))
                    .andReturn();
            assertNull(result.getRequest().getSession().getAttribute("administrationId"));
            assertFalse(result.getFlashMap().toString().contains("wrong"));
        }
    }
}
