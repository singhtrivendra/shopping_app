# 🛒 Shopping App  

A Flutter-based **shopping cart app** using **Bloc** for state management. The app fetches products from an API, supports **pagination**, calculates **discounted prices**, and allows users to add/remove items from the cart.  

## 📽️ Demo & Screenshots  

## 🔹 Screenshots  

<div style="display: flex; gap: 10px;">
  <img src="https://github.com/user-attachments/assets/24564e98-2bd6-4557-9b58-df132a90c6d4" alt="Home Screen" width="400" height="600">
  <img src="https://github.com/user-attachments/assets/7732c248-5d98-41fc-aeec-7e0c7be161db" alt="Cart Screen" width="400" height="600">
</div>  

## 🔹 Demo Video  

[Click here to watch](https://github.com/user-attachments/assets/7391e97a-2fbf-4e3e-b4bf-fc7234d1f846)  

<video width="700" height="400" controls>
  <source src="https://github.com/user-attachments/assets/7391e97a-2fbf-4e3e-b4bf-fc7234d1f846" type="video/mp4">
  Your browser does not support the video tag.
</video>


 

## 🚀 Features  

✅ **Product Listing with Pagination** - Fetch products dynamically from [DummyJSON API](https://dummyjson.com/products)  
✅ **Infinite Scrolling** - Uses `ScrollController` for loading more products  
✅ **State Management** - Efficiently implemented with `Bloc`  
✅ **Cart System** - Add, remove, and update products in the cart  
✅ **Discounted Price Calculation** - Displays final price after applying discounts  
✅ **Pull to Refresh** - Integrated with `RefreshIndicator`  

## 🏗️ Folder Structure  

```plaintext
📦 lib
 ┣ 📂 core
 ┃ ┣ 📂 constants
 ┃ ┃ ┗ 📜 app_colors.dart
 ┃ ┣ 📂 themes
 ┃ ┃ ┗ 📜 app_theme.dart
 ┣ 📂 data
 ┃ ┣ 📂 models
 ┃ ┃ ┗ 📜 product_model.dart
 ┃ ┣ 📂 repositories
 ┃ ┃ ┗ 📜 api_service.dart
 ┣ 📂 presentation
 ┃ ┣ 📂 bloc
 ┃ ┃ ┣ 📜 product_bloc.dart
 ┃ ┃ ┗ 📜 product_state.dart
 ┃ ┣ 📂 screens
 ┃ ┃ ┣ 📜 cart_screen.dart
 ┃ ┃ ┗ 📜 catalogue_screen.dart
 ┣ 📂 utils
 ┃ ┗ 📜 number_formatters.dart
 ┗ 📜 main.dart
```
## 🔧 Installation & Setup
# 1️⃣ Clone the repository

```sh
git clone https://github.com/singhtrivendra/shopping_app.git
cd shopping_app
```
# 2️⃣ Install dependencies

```sh
flutter pub get
```
# 3️⃣ Run the app

```sh
flutter run
```
## 🏆 Optimization Techniques Used  
✅ **BlocBuilder for efficient UI updates** <br>  
✅ **ScrollController for infinite scrolling** <br>  
✅ **Pagination using _onScroll()** <br>  
✅ **RefreshIndicator for pull-to-refresh** <br>  
✅ **BlocSelector for minimizing unnecessary rebuilds**  


📜 API Used
This project fetches product data from DummyJSON API:
🔗 https://dummyjson.com/products

For any queries or collaboration, feel free to contact:
📧 trivendrasingh0711@gmail.com

