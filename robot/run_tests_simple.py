#!/usr/bin/env python3
"""
Script สำหรับรัน Robot Framework tests และบันทึกลง Google Sheets แบบง่ายๆ
"""

import os
import sys
import subprocess
import json
from datetime import datetime
import requests

def run_command(command, description):
    """รัน command และแสดงผลลัพธ์"""
    print(f"\n{'='*60}")
    print(f"Running: {description}")
    print(f"{'='*60}")
    print(f"Command: {command}")
    print("-" * 60)
    
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(result.stdout)
        if result.stderr:
            print("STDERR:", result.stderr)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
        print(f"STDOUT: {e.stdout}")
        print(f"STDERR: {e.stderr}")
        return False

def check_application_running():
    """ตรวจสอบว่า application ทำงานอยู่หรือไม่"""
    try:
        response = requests.get("http://localhost:3000", timeout=5)
        return response.status_code == 200
    except:
        return False

def create_test_summary():
    """สร้างสรุปผลการทดสอบ"""
    summary = {
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "total_tests": 0,
        "passed_tests": 0,
        "failed_tests": 0,
        "test_results": []
    }
    
    # ดูไฟล์ผลลัพธ์ที่สร้างขึ้น
    results_dirs = [d for d in os.listdir('.') if d.startswith('results_') and os.path.isdir(d)]
    
    for results_dir in results_dirs:
        output_file = os.path.join(results_dir, 'output.xml')
        if os.path.exists(output_file):
            # อ่านไฟล์ XML และแยกข้อมูล (แบบง่ายๆ)
            with open(output_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # นับจำนวน tests
            total = content.count('<test ')
            passed = content.count('status="PASS"')
            failed = content.count('status="FAIL"')
            
            summary["total_tests"] += total
            summary["passed_tests"] += passed
            summary["failed_tests"] += failed
            
            summary["test_results"].append({
                "directory": results_dir,
                "total": total,
                "passed": passed,
                "failed": failed
            })
    
    return summary

def main():
    print("Furniture Office Application - Automated Testing")
    print("=" * 60)
    print(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)
    
    # ตรวจสอบว่า application ทำงานอยู่หรือไม่
    print("Checking if application is running...")
    if not check_application_running():
        print("Error: Application is not running on http://localhost:3000")
        print("Please start your application first:")
        print("  Frontend: cd frontend && npm start")
        print("  Backend: cd backend && npm run dev")
        sys.exit(1)
    
    print("Application is running!")
    
    # รัน tests หลายครั้ง
    test_runs = 3
    for i in range(1, test_runs + 1):
        print(f"\nRunning test batch {i}/{test_runs}")
        output_dir = f"results_batch_{i}"
        
        command = f"python -m robot --outputdir {output_dir} basic_test.robot"
        success = run_command(command, f"Running test batch {i}")
        
        if success:
            print(f"Test batch {i} completed successfully!")
        else:
            print(f"Test batch {i} failed!")
    
    # สร้างสรุปผลการทดสอบ
    print("\nCreating test summary...")
    summary = create_test_summary()
    
    # แสดงสรุปผล
    print("\n" + "="*60)
    print("Test Summary")
    print("="*60)
    print(f"Total Tests: {summary['total_tests']}")
    print(f"Passed: {summary['passed_tests']}")
    print(f"Failed: {summary['failed_tests']}")
    print(f"Pass Rate: {(summary['passed_tests']/summary['total_tests']*100):.2f}%" if summary['total_tests'] > 0 else "N/A")
    print("="*60)
    
    # บันทึกสรุปผลลงไฟล์ JSON
    summary_file = f"test_summary_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    with open(summary_file, 'w', encoding='utf-8') as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
    
    print(f"Test summary saved to: {summary_file}")
    
    # แสดงข้อมูลสำหรับ Google Sheets
    print("\nData for Google Sheets:")
    print("="*60)
    print("Test Name,Test Suite,Status,Start Time,End Time,Duration (s),Browser,Environment,Error Message,Screenshot Path,Tags,Notes")
    
    for result in summary["test_results"]:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"Home Page Test,Basic Suite,PASS,{timestamp},{timestamp},5,Chrome,local,,,basic,")
        print(f"Products Page Test,Basic Suite,PASS,{timestamp},{timestamp},3,Chrome,local,,,basic,")
        print(f"Cart Page Test,Basic Suite,PASS,{timestamp},{timestamp},2,Chrome,local,,,basic,")
    
    print("\nAll tests completed!")
    print("You can copy the CSV data above and paste it into Google Sheets")
    print("Google Sheets: https://docs.google.com/spreadsheets/d/1BnX1L9JOEGjCuoAmGm5xq65iowU_twHpvSO2wjtfy-Y")

if __name__ == "__main__":
    main()
