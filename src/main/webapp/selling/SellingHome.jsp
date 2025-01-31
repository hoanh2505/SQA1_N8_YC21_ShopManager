<%--
  Created by IntelliJ IDEA.
  User: nndng
  Date: 3/21/2022
  Time: 4:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Bán hàng</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="bootstraplib/bootstrap.4.0.0.min.css" crossorigin="anonymous">
    <script src="bootstraplib/jquery-3.2.1.js" crossorigin="anonymous"></script>
    <script src="bootstraplib/popper.min.js" crossorigin="anonymous"></script>
    <script src="bootstraplib/bootstrap.min.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <%--    <style>--%>
    <%--        .container--%>
    <%--    </style>--%>
</head>
<body>
<body>
<div class="container-fluid">
    <div class="container-xl" style="border:1px solid #cecece;">
        <div class="row">
            <div class="col-md-6" style="border:1px solid #cecece;">
                <form action="<c:url value="/SellServlet"/>" method="post">
                    <input type="text" name="goodsname" placeholder="Nhập tên mặt hàng"/>
                    <input type="hidden" name="action" value="search_goods">
                    <button class="btn btn-primary" type="submit">Tìm</button>
                </form>

                <form action="<c:url value="/SellServlet"/>" method="post">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Tên</th>
                                <th>Đơn vị</th>
                                <th>Giá</th>
                                <th>Chọn</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr></tr>
                            <tr></tr>
                            <c:forEach items="${goodsList}" var="element" varStatus="status">
                                <tr>
                                    <td>${element.name}</td>
                                    <td>${element.unity}</td>
                                    <td>${element.pricePerUnit}</td>
                                    <td><input type="radio" name="chooseIndex" value="${status.count}"></td>
                                </tr>
                            </c:forEach>

                            </tbody>

                        </table>
                    </div>
                    <input type="text" pattern="[0-9]+" name="amount" placeholder="Số lượng mặt hàng"/>
                    <input type="hidden" name="action" value="add_goods">
                    <button class="btn btn-primary" type="submit">Thêm</button>
                </form>
            </div>

            <div class="col-md-6" style="border:1px solid #cecece;">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>Tên</th>
                            <th>Đơn vị</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${bill.buyingGoodsList}" var="element" varStatus="status">
                            <tr>
                                <td>${element.goods.name}</td>
                                <td>${element.goods.unity}</td>
                                <td>${element.goods.pricePerUnit}</td>
<%--                                <td>${element.amount}</td>--%>
                                <td>
                                    <form action="<c:url value="/SellServlet"/>" method="post">
                                        <input type="text" name="amount" placeholder="Số lượng mặt hàng"
                                               value="${element.amount}" size="2" maxlength="5"/>
                                        <input type="hidden" name="action" value="update_goods">
                                        <input type="hidden" name="index" value="${status.count}">

                                </td>
                                <td>
                                        <input type="submit" value="Update">
                                    </form>
                                </td>
                                <td>
                                    <form action="<c:url value="/SellServlet"/>" method="post">
                                        <input type="hidden" name="action" value="remove_goods">
                                        <input type="hidden" name="index" value="${status.count}">
                                        <input type="submit" value="Remove">
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>

                        </tbody>
                    </table>
                </div>
                <div>
                    <label>Tổng tiền: ${bill.paymentTotal}</label>
                </div>
            </div>
        </div>
    </div>
    <br>
    <div class="container">
        <div class="row">
            <div class="col-md-8" style="border:1px solid #cecece;">
                <form action="<c:url value="/SellServlet"/>" method="post">
                    <input type="hidden" name="action" value="find_client">
                    <label for="name" class="form-label">Tên</label>
                    <input id="name" type="text" name="client_name" value="${bill.client.name}"/>
                    &nbsp;
                    <label for="phoneNumber" class="form-label">Số điện thoại</label>
                    <input id="phoneNumber" type="text" pattern="(84|0[3|5|7|8|9])+([0-9]{8})\b"
                           name="client_phone" value="${bill.client.phoneNumber}"/>
                    &nbsp;
                    <button class="btn btn-primary" type="submit">Tìm khách hàng</button>
                </form>
                <form action="<c:url value="/SellServlet"/>" method="post">
                    <input type="hidden" name="action" value="choose_client">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Tên</th>
                                <th>Số điện thoại</th>
                                <th>Địa chỉ</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${listClient}" var="element" varStatus="status">
                                <tr>
                                    <td>${element.name}</td>
                                    <td>${element.phoneNumber}</td>
                                    <td>${element.address}</td>
                                    <td><input type="radio" name="chooseIndex" value="${status.count}"></td>
                                </tr>
                            </c:forEach>

                            </tbody>
                        </table>
                    </div>
                    <button class="btn btn-primary" type="submit">Chọn khách hàng</button>
                </form>


            </div>
            <div class="col-md-4" style="border:1px solid #cecece;">
                <form action="<c:url value="/SellServlet"/>" method="get">
                    <input type="hidden" name="action" value="add_client">
                    <button class="btn btn-primary" type="submit">Thêm khách hàng</button>
                </form>
                <br>
                <form action="<c:url value="/SellServlet"/>" method="get">

                    <label>Giảm giá: </label><input type="text" name="sale_off" value="0.0"> <br>
                    <input type="hidden" name="action" value="confirm_bill">
                    <button class="btn btn-primary" type="submit">Lưu hoá đơn</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>

</body>
</html>
