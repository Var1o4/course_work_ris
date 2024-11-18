 <#import "../parts/common.ftlh" as c>

<@c.page>
<div class="container mt-5">
    <h2>Оплата платежа</h2>
    <div class="card">
        <div class="card-body">
            <h5 class="card-title">${(payment.name)!''}</h5>
            <p class="card-text">Сумма к оплате: ${(payment.amount)!'0.00'} BYN</p>
            
            <#if invoices?? && invoices?size gt 0>
                <form action="/payments/${(payment.id)!''}/process" method="POST">
                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                    
                    <div class="form-group mb-3">
                        <label for="invoiceId">Счет для оплаты:</label>
                        <select class="form-control" id="invoiceId" name="invoiceId" required>
                            <#-- Сначала выводим главный счет -->
                            <#list invoices as invoice>
                                <#if invoice.mainAccount>
                                    <option value="${invoice.invoiceId}" selected>
                                        Счет №${invoice.invoiceId} (Основной) (Баланс: ${invoice.amount} BYN)
                                    </option>
                                </#if>
                            </#list>
                            
                            <#-- Затем выводим остальные счета -->
                            <#list invoices as invoice>
                                <#if !invoice.mainAccount>
                                    <option value="${invoice.invoiceId}">
                                        Счет №${invoice.invoiceId} (Баланс: ${invoice.amount} BYN)
                                    </option>
                                </#if>
                            </#list>
                        </select>
                    </div>

                    <#if payment?? && !payment.fixedPrice>
                        <div class="form-group mb-3">
                            <label for="amount">Сумма платежа:</label>
                            <input type="number" class="form-control" id="amount" name="amount" 
                                   step="0.01" min="0.01" required>
                        </div>
                    <#else>
                        <input type="hidden" name="amount" value="${(payment.amount)!'0.00'}">
                    </#if>

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="/payments/my" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Назад
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-credit-card"></i> Подтвердить оплату
                        </button>
                    </div>
                </form>
            <#else>
                <div class="alert alert-warning">
                    У вас нет активных счетов. Пожалуйста, <a href="/bills/create">создайте счет</a> для совершения платежа.
                </div>
            </#if>
        </div>
    </div>
</div>

<style>
    .card {
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .btn {
        padding: 8px 16px;
        border-radius: 4px;
    }
    .btn-primary {
        background-color: #1976d2;
        border-color: #1976d2;
    }
    .btn-secondary {
        background-color: #757575;
        border-color: #757575;
    }
    .form-control {
        border-radius: 4px;
        border: 1px solid #ddd;
        padding: 8px 12px;
    }
    .alert {
        border-radius: 4px;
    }
</style>
</@c.page>