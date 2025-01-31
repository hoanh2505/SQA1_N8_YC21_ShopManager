package com.duynn.sqa1_n8_yc21_shopmanager.servlet.selling;

import com.duynn.sqa1_n8_yc21_shopmanager.DAO.BillDAO;
import com.duynn.sqa1_n8_yc21_shopmanager.DAO.ClientDAO;
import com.duynn.sqa1_n8_yc21_shopmanager.DAO.GoodsDAO;
import com.duynn.sqa1_n8_yc21_shopmanager.model.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "SellServlet", value = "/SellServlet")
public class SellServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ServletContext context = getServletContext();
        HttpSession session = request.getSession();

        String url="/";
        String action = "";
        action = request.getParameter("action");
        if (action == null)
            action ="";
        if(action.equals("") || action==null){
            Bill bill = new Bill();
            bill.setUser((User) session.getAttribute("user"));
            session.setAttribute("bill",bill);
            url="/selling/SellingHome.jsp";

        }else if(action.equals("search_goods")){
            List<Goods> goodsList = new GoodsDAO().searchByName(request.getParameter("goodsname"));
            session.setAttribute("goodsList",goodsList);
            url="/selling/SellingHome.jsp";

        }else if(action.equals("add_client")){
            List<Goods> goodsList = new GoodsDAO().searchByName(request.getParameter("goodsname"));
            session.setAttribute("goodsList",goodsList);
            session.setAttribute("status","add_from_sell");
            url="/client/AddClient.jsp";

        }else if(action.equals("confirm_bill")){
            session.removeAttribute("goodsList");
            session.removeAttribute("listClient");


            Bill bill = (Bill) session.getAttribute("bill");
            bill.setSaleOff(Float.parseFloat(request.getParameter("sale_off")));
            bill.setPaymentDate(LocalDateTime.now());

            url="/selling/Confirm.jsp";

        }
        context.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletContext context = getServletContext();
        HttpSession session = request.getSession();

        String url="/";
        String action = "";
        action = request.getParameter("action");
        if(action.equals("search_goods")){
            List<Goods> goodsList = new GoodsDAO().searchByName(request.getParameter("goodsname"));
            session.setAttribute("goodsList",goodsList);
            url="/selling/SellingHome.jsp";

        }else if(action.equals("add_goods")){
            Bill bill = (Bill) session.getAttribute("bill");
            List<Goods> goodsList = (List<Goods>) session.getAttribute("goodsList");
            int amount = Integer.parseInt(request.getParameter("amount"));

            Goods goods = goodsList.get(Integer.parseInt(request.getParameter("chooseIndex"))-1);
            BuyingGoods buyingGoods = new BuyingGoods();
            buyingGoods.setGoods(goods);
            buyingGoods.setAmount(amount);
            buyingGoods.setPricePerUnit(goods.getPricePerUnit());
            buyingGoods.setTotalPrice(amount*goods.getPricePerUnit());

            bill.addBuyingGoods(buyingGoods);
            bill.reCalPaymentTotal();

            url="/selling/SellingHome.jsp";
        }else if(action.equals("find_client")){
            try {
                List<Client> listClient = new ClientDAO().searchClient(request.getParameter("client_phone"));
                session.setAttribute("listClient",listClient);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            url="/selling/SellingHome.jsp";
        }else if(action.equals("choose_client")){
            List<Client> list = (List<Client>) session.getAttribute("listClient");
            Client client = list.get(Integer.parseInt(request.getParameter("chooseIndex"))-1);
            Bill bill = (Bill) session.getAttribute("bill");
            bill.setClient(client);

            System.out.println(bill.getClient());

            url="/selling/SellingHome.jsp";
        }else if(action.equals("save_bill")){
            Bill bill = (Bill) session.getAttribute("bill");
            bill.setPaid(true);
            new BillDAO().save(bill);
            session.removeAttribute("bill");
            request.getSession().setAttribute("confirmBillMsg", "Lưu thành công");
            url="/seller/SellerHome.jsp";
        }else if(action.equals("cancel_bill")){
            session.removeAttribute("bill");
            url="/seller/SellerHome.jsp";
        }else if(action.equals("update_goods")){
            Bill bill = (Bill) session.getAttribute("bill");
            //update hang
            int amount = Integer.parseInt(request.getParameter("amount"));
            int index = Integer.parseInt(request.getParameter("index")) -1;
            if(amount <= 0) {
                bill.getBuyingGoodsList().remove(index);
            }else {
                bill.getBuyingGoodsList().get(index).setAmount(amount);
            }

            //update tong tien bill
            bill.reCalPaymentTotal();

            session.setAttribute("bill",bill);
            url="/selling/SellingHome.jsp";
        }else if(action.equals("remove_goods")){
            Bill bill = (Bill) session.getAttribute("bill");
            int index = Integer.parseInt(request.getParameter("index")) -1 ;
            bill.getBuyingGoodsList().remove(index);
            bill.reCalPaymentTotal();

            session.setAttribute("bill",bill);
            url="/selling/SellingHome.jsp";

        }
        context.getRequestDispatcher(url).forward(request, response);
    }
}
