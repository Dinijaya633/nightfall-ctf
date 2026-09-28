document.addEventListener("DOMContentLoaded", () => {

    const passwordInput = document.getElementById("password");
    const passwordToggle = document.getElementById("passwordToggle");
    const loginCard = document.getElementById("loginCard");
    const loginError = document.getElementById("loginError");

    if (passwordToggle && passwordInput) {

        passwordToggle.addEventListener("click", () => {

            const hidden = passwordInput.type === "password";

            passwordInput.type = hidden ? "text" : "password";
            passwordToggle.textContent = hidden ? "HIDE" : "SHOW";
            passwordToggle.setAttribute(
                "aria-label",
                hidden ? "Hide password" : "Show password"
            );

        });

    }

    if (loginCard && loginError) {

        loginCard.classList.remove("shake");

        requestAnimationFrame(() => {
            loginCard.classList.add("shake");
        });

        setTimeout(() => {
            loginCard.classList.remove("shake");
        }, 650);

    }

});