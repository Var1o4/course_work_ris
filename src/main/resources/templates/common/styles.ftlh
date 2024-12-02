<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        background-color: #f5f5f5;
    }

    .menu {
        width: 250px;
        background-color: #2e7d32;
        color: white;
        padding: 20px;
        min-height: 100vh;
    }

    .app-title {
        font-size: 24px;
        font-weight: bold;
        color: white;
        margin-bottom: 30px;
        padding-bottom: 15px;
        border-bottom: 2px solid rgba(255, 255, 255, 0.2);
    }

    .menu-items {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .menu-item {
        position: relative;
        color: white;
        text-decoration: none;
        padding: 10px;
        border-radius: 5px;
        transition: background-color 0.3s;
    }

    .menu-item:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    .has-submenu {
        cursor: pointer;
    }

    .submenu {
        display: none;
        position: absolute;
        left: 100%;
        top: 0;
        background-color: #2e7d32;
        padding: 10px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        min-width: 150px;
    }

    .has-submenu:hover .submenu {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }

    .submenu a {
        color: white;
        text-decoration: none;
        padding: 5px 10px;
        border-radius: 3px;
    }

    .submenu a:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    .content {
        flex: 1;
        padding: 20px;
    }
</style> 