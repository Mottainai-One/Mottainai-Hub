package com.mottainai.crudinicial.controller;

import com.mottainai.crudinicial.security.AdministrationAuthService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

// ENTRADA HTTP DO LOGIN ADMINISTRATIVO — /login E /logout
// Coordena AdministrationAuthService e HttpSession; o DAO de credenciais é acessado somente pelo Service.


@Controller
public class AuthenticationController {
    private final AdministrationAuthService authService;

    public AuthenticationController(AdministrationAuthService authService) {
        this.authService = authService;
    }

    // FLUXO DE SAÍDA
    // POST invalida a sessão atual; o redirect para /login não mantém os atributos administrativos.
    @PostMapping("/logout")
    public String logout(HttpServletRequest request) {
        // ENCERRAMENTO DA SESSÃO: invalida todos os atributos administrativos sem criar outra sessão.
        var session = request.getSession(false);
        if (session != null) session.invalidate();
        return "redirect:/login";
    }

    // FLUXO DE LOGIN
    // email/password seguem ao Service; credenciais inválidas não criam autenticação e retornam flash erro.
    // Após BCrypt válido, uma nova sessão recebe somente administrationId/administrationEmail e segue para /inicio.
    @PostMapping("/login")
    public String login(@RequestParam(name = "email", required = false) String email,
                        @RequestParam(name = "password", required = false) String password,
                        HttpServletRequest request, RedirectAttributes flash) {
        try {
            var account = authService.authenticate(email, password);
            if (account.isEmpty()) {
                flash.addFlashAttribute("erro", "E-mail ou senha inválidos.");
                return "redirect:/login";
            }
            // NOVA SESSÃO: descarta o identificador pré-login; somente ID e email são mantidos.
            var previous = request.getSession(false);
            if (previous != null) previous.invalidate();
            var session = request.getSession(true);
            session.setAttribute("administrationId", account.get().getAdministrationId());
            session.setAttribute("administrationEmail", account.get().getEmail());
            return "redirect:/inicio";
        } catch (DataAccessException ex) {
            flash.addFlashAttribute("erro", "Não foi possível entrar agora. Tente novamente em instantes.");
            return "redirect:/login";
        }
    }
}
