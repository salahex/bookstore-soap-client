<%@page import="dev.salah.ws.User"%>
<%@page import="dev.salah.Utils"%>
<% Utils.markAsPrivate(request, response, true);%>
<%@page import="java.util.Base64"%>
<%@page import="dev.salah.services.BookWS"%>
<%@page import="dev.salah.services.CategoryWS"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%!
    String title = "Books Dashboard";

    String isActive(String name) {
        return title == name ? "active" : "";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <link rel="shortcut icon" type="image/png" href="${pageContext.servletContext.contextPath}/assets/favicon.png" />
        <meta name="viewport" content="width=device-width" />
        <title><%= title%></title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" />
        <link rel="stylesheet" href="../styles/Books/index.css" />
    </head>
    <body>
        <header>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <a class="navbar-brand mb-0 h1" href="${pageContext.servletContext.contextPath}">Book Library</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav mr-auto">
                        <li class="nav-item <%= isActive("Home")%>">
                            <a class="nav-link" href="${pageContext.servletContext.contextPath}">Home</a>
                        </li>
                        <li class="nav-item <%= isActive("Books")%>">
                            <a class="nav-link" href="${pageContext.servletContext.contextPath}/Home/Books.jsp">Books</a>
                        </li>
                        <li class="nav-item dropdown <%= isActive(title.contains("-") ? title : "")%>">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Categories
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <c:forEach var="category" items="<%= CategoryWS.read()%>">
                                    <a class="dropdown-item" href="${pageContext.servletContext.contextPath}/Home/Books.jsp?categoryID=${category.id}">${category.name}</a>
                                </c:forEach>
                            </div>
                        </li>
                    </ul>
                    <c:if test="${ user != null && user.role == 'admin' }">
                        <ul class="navbar-nav mr-1">
                            <li class="nav-item">
                                <a class="nav-link <%= isActive("Users Dashboard")%>" href="${pageContext.servletContext.contextPath}/Users">
                                    <%@include file="/Icons/_userIcon.jsp" %>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <%= isActive("Books Dashboard")%>" href="${pageContext.servletContext.contextPath}/Books">
                                    <%@include file="/Icons/_bookIcon.jsp" %>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <%= isActive("Categories Dashboard")%>" href="${pageContext.servletContext.contextPath}/Categories">
                                    <%@include file="/Icons/_categoryIcon.jsp" %>
                                </a>
                            </li>
                        </ul>
                    </c:if>

                    <form class="custom-form custom-form-inline" action="${pageContext.servletContext.contextPath}/Home/Search.jsp" autocomplete="off">
                        <input class="custom-form-input" type="search" placeholder="Search" name="q" required>
                        <button class="custom-form-button" type="submit">Search</button>
                    </form>
                    <ul class="navbar-nav mr-2">
                        <li class="nav-item <%= isActive("Cart")%>">
                            <a class="nav-link cart" href="${pageContext.servletContext.contextPath}/Home/Cart.jsp">
                                <div class="svg">
                                    <%@include file="/Icons/_cartIcon.jsp" %>
                                    <c:if test="${cart != null && cart.size() != 0}">
                                        <div class="tracker">${cart.size()}</div>
                                    </c:if>
                                </div>
                            </a>
                        </li>
                    </ul>
                    <c:choose>
                        <c:when test="${user != null}">
                            <ul class="navbar-nav mr-1">
                                <li class="nav-item flex-username">
                                    <a class="nav-link" href="${pageContext.servletContext.contextPath}/Home/ProfileDetails.jsp">${user.username}</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.servletContext.contextPath}/Home/Logout.jsp"><%@include file="/Icons/_logoutIcon.jsp" %></a>
                                </li>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <ul class="navbar-nav">
                                <li class="nav-item <%= isActive("Login")%>">
                                    <a class="nav-link" href="${pageContext.servletContext.contextPath}/Home/Login.jsp">Login</a>
                                </li>
                                <li class="nav-item <%= isActive("Register")%>">
                                    <a class="nav-link" href="${pageContext.servletContext.contextPath}/Home/Register.jsp">Register</a>
                                </li>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>
        </header>
        <main>
            <div class="container">
                <div class="table">
                    <div class="tr tb">
                        <a href="${pageContext.servletContext.contextPath}/Books/Create.jsp">Add Book</a>
                    </div>
                    <c:forEach var="book" items="<%= BookWS.read()%>">
                        <c:set var="thumbnail" value="${book.thumbnail}" />
                        <div class="tr">
                            <div class="td">
                                <img src="data:image/png;base64, <%= Base64.getEncoder().encodeToString((byte[]) pageContext.getAttribute("thumbnail"))%>" />
                            </div>
                            <div class="td">
                                <div class="tg">
                                    <div class="tk">Title</div>
                                    <div class="tv">${book.title}</div>
                                </div>
                                <div class="tg">
                                    <div class="tk">Author</div>
                                    <div class="tv">${book.author}</div>
                                </div>
                                <div class="tg">
                                    <div class="tk">Category</div>
                                    <div class="tv">${book.categoryID.name}</div>
                                </div>
                                <div class="tg tl">
                                    <div class="tk">Price</div>
                                    <div class="tv">${book.price}</div>
                                </div>
                                <div class="ta">${book.count}</div>
                            </div>

                            <div class="td">
                                <a href="${pageContext.servletContext.contextPath}/Books/Edit.jsp?id=${book.id}">Edit</a>
                                <a href="${pageContext.servletContext.contextPath}/Books/Details.jsp?id=${book.id}">Details</a>
                                <a href="${pageContext.servletContext.contextPath}/Books/Delete.jsp?id=${book.id}">Delete</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>
        <footer class="page-footer font-small blue pt-4">
            <div class="container-fluid text-center text-md-left">
                <div class="row">
                    <div class="col-md-6 mt-md-0 mt-3">
                        <h5 class="text-uppercase">Content</h5>
                        <p>Our aim is to provide the best books and customer service. With an experience of 15 years and more we can guarantee that we will make you happy.</p>
                    </div>
                    <hr class="clearfix w-100 d-md-none pb-3">
                    <div class="col-md-3 mb-md-0 mb-3">
                        <h5 class="text-uppercase">NAVIGATE</h5>

                        <ul class="list-unstyled">
                            <li>
                                <a href="${pageContext.servletContext.contextPath}/">Home</a>
                            </li>
                            <li>
                                <a href="${pageContext.servletContext.contextPath}/Home/Books.jsp">Books</a>
                            </li>
                            <li>
                                <a href="${pageContext.servletContext.contextPath}/Home/Cart.jsp">Cart</a>
                            </li>
                        </ul>

                    </div>
                    <div class="col-md-3 mb-md-0 mb-3">
                        <h5 class="text-uppercase">Contact</h5>
                        <div>Email: lachkar.se@gmail.com</div>
                        <div>Tel: 0693801823</div>
                        Website: <a href="https://salah.dev/" target="_blank">https://salah.dev/</a>
                    </div>
                </div>
            </div>
            <div class="footer-copyright text-center py-3">
                <a href="${pageContext.servletContext.contextPath}"> Book Store</a> © 2019
            </div>
        </footer>
        <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    </body>
</html>


