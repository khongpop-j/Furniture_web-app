#!/usr/bin/env python3
"""
Script สำหรับตรวจสอบ HTML structure ของ application
"""

import requests
from bs4 import BeautifulSoup
import time

def check_application_structure():
    """ตรวจสอบ HTML structure ของ application"""
    print("Furniture Office Application - Structure Analysis")
    print("=" * 60)
    
    # ตรวจสอบหน้าแรก
    print("\n1. Checking home page (/)")
    try:
        response = requests.get("http://localhost:3000", timeout=10)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # หา navigation elements
            nav_links = soup.find_all('a', href=True)
            print("Navigation links found:")
            for link in nav_links:
                print(f"  - {link.get('href')}: {link.get_text().strip()}")
            
            # หา buttons
            buttons = soup.find_all('button')
            print("Buttons found:")
            for btn in buttons:
                print(f"  - {btn.get('class')}: {btn.get_text().strip()}")
            
            # หา input fields
            inputs = soup.find_all('input')
            print("Input fields found:")
            for inp in inputs:
                print(f"  - {inp.get('name')}: {inp.get('type')} - {inp.get('class')}")
                
        else:
            print(f"Error: Status code {response.status_code}")
    except Exception as e:
        print(f"Error: {e}")
    
    # ตรวจสอบหน้า login
    print("\n2. Checking Login page (/login)")
    try:
        response = requests.get("http://localhost:3000/login", timeout=10)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # หา form elements
            forms = soup.find_all('form')
            print("Forms found:")
            for form in forms:
                print(f"  - Form: {form.get('class')}")
                
                # หา input fields ใน form
                inputs = form.find_all('input')
                for inp in inputs:
                    print(f"    - Input: {inp.get('name')} ({inp.get('type')}) - {inp.get('class')}")
                
                # หา buttons ใน form
                buttons = form.find_all('button')
                for btn in buttons:
                    print(f"    - Button: {btn.get('type')} - {btn.get_text().strip()}")
        else:
            print(f"Error: Status code {response.status_code}")
    except Exception as e:
        print(f"Error: {e}")
    
    # ตรวจสอบหน้า products
    print("\n3. Checking Products page (/products)")
    try:
        response = requests.get("http://localhost:3000/products", timeout=10)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # หา product items
            products = soup.find_all('div', class_=lambda x: x and 'product' in x.lower())
            print(f"Product items found: {len(products)}")
            
            # หา add to cart buttons
            add_buttons = soup.find_all('button', class_=lambda x: x and 'add' in str(x).lower())
            print("Add to cart buttons found:")
            for btn in add_buttons:
                print(f"  - {btn.get('class')}: {btn.get_text().strip()}")
            
            # หา filter elements
            selects = soup.find_all('select')
            print("Select elements found:")
            for sel in selects:
                print(f"  - {sel.get('class')}: {sel.get('name')}")
        else:
            print(f"Error: Status code {response.status_code}")
    except Exception as e:
        print(f"Error: {e}")
    
    # ตรวจสอบหน้า cart
    print("\n4. Checking Cart page (/cart)")
    try:
        response = requests.get("http://localhost:3000/cart", timeout=10)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # หา cart elements
            cart_items = soup.find_all('div', class_=lambda x: x and 'cart' in str(x).lower())
            print(f"Cart items found: {len(cart_items)}")
            
            # หา buttons
            buttons = soup.find_all('button')
            print("Buttons found:")
            for btn in buttons:
                print(f"  - {btn.get('class')}: {btn.get_text().strip()}")
        else:
            print(f"Error: Status code {response.status_code}")
    except Exception as e:
        print(f"Error: {e}")
    
    # ตรวจสอบหน้า checkout
    print("\n5. Checking Checkout page (/checkout)")
    try:
        response = requests.get("http://localhost:3000/checkout", timeout=10)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # หา form elements
            forms = soup.find_all('form')
            print("Forms found:")
            for form in forms:
                print(f"  - Form: {form.get('class')}")
                
                # หา input fields
                inputs = form.find_all('input')
                for inp in inputs:
                    print(f"    - Input: {inp.get('name')} ({inp.get('type')}) - {inp.get('class')}")
                
                # หา buttons
                buttons = form.find_all('button')
                for btn in buttons:
                    print(f"    - Button: {btn.get('type')} - {btn.get_text().strip()}")
        else:
            print(f"Error: Status code {response.status_code}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_application_structure()
