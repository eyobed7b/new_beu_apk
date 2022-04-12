import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/repository/cart_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/product_model.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;

  CartController({@required this.cartRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;
  bool _isCartOpen = false;

  List<CartModel> get cartList => _cartList;
  double get amount => _amount;
  bool get isCartOpen => _isCartOpen;

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice * cart.quantity);
    });
  }

  void openCart() {
    _isCartOpen = true;
    update();
  }

  void closeCart() {
    _isCartOpen = false;
    update();
  }

  void addToCart(CartModel cartModel) {
    if (getQuantity(cartModel.product) != 0) {
      // _amount = _amount -
      //     (_cartList[index].discountedPrice * _cartList[index].quantity);
      // _cartList.replaceRange(index, index + 1, [cartModel]);
      int i = getIndex(cartModel.product);
      _cartList[i].quantity += 1;
    } else {
      _cartList.add(cartModel);
    }
    _amount = _amount + (cartModel.discountedPrice * cartModel.quantity);
    cartRepo.addToCartList(_cartList);
    print("CartCart: item added to cart");
    update();
  }

  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
      _amount = _amount + _cartList[index].discountedPrice;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
      _amount = _amount - _cartList[index].discountedPrice;
    }
    cartRepo.addToCartList(_cartList);

    update();
  }

  void removeFromCart(Product product) {
    if (getQuantity(product) > 1) {
      _cartList[getIndex(product)].quantity -= 1;
      _amount -= product.price;
    } else if (getQuantity(product) == 1) {
      _cartList.removeAt(getIndex(product));
      _amount -= product.price;
    }

    cartRepo.addToCartList(_cartList);
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo.addToCartList(_cartList);
    update();
  }

  bool isExistInCart(CartModel cartModel, bool isUpdate, int cartIndex) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == cartModel.product.id &&
          (_cartList[index].variation.length > 0
              ? _cartList[index].variation[0].type ==
                  cartModel.variation[0].type
              : true)) {
        if ((isUpdate && index == cartIndex)) {
          return false;
        } else {
          return true;
        }
      }
    }
    return false;
  }

  int getIndex(Product product) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == product.id) {
        return index;
      }
    }
    return -1;
  }

  int getQuantity(Product product) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == product.id) {
        return cartList[index].quantity;
      }
    }
    return 0;
  }

  bool existAnotherRestaurantProduct(int restaurantID) {
    for (CartModel cartModel in _cartList) {
      if (cartModel.product.restaurantId != restaurantID) {
        return true;
      }
    }
    return false;
  }

  void removeAllAndAddToCart(CartModel cartModel) {
    _cartList = [];
    _cartList.add(cartModel);
    _amount = cartModel.discountedPrice * cartModel.quantity;
    cartRepo.addToCartList(_cartList);
    update();
  }
}
