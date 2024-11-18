<#macro page>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Платежная система</title>
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" 
              rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" 
              rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
            <div class="container">
                <a class="navbar-brand" href="/">Платежная система</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                        data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="/payments/my">Мои платежи</a>
                        </li>
                        <#if user?? && user.hasRole('ROLE_ADMIN')>
                            <li class="nav-item">
                                <a class="nav-link" href="/payments/all">Все платежи</a>
                            </li>
                        </#if>
                    </ul>
                    <#if user??>
                        <span class="navbar-text me-3">
                            ${user.email}
                        </span>
                        <form action="/logout" method="post" class="d-flex">
                            <button class="btn btn-outline-light" type="submit">Выйти</button>
                        </form>
                    </#if>
                </div>
            </div>
        </nav>

        <#nested>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
</#macro> 