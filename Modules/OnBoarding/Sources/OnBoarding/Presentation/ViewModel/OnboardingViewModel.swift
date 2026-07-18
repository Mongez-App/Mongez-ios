//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 17/07/2026.
//

import Foundation
import Combine

public class OnboardingViewModel : ObservableObject{
    @Published public var currentPage : Int = 0
    public let steps : [OnboardingStep] = [
        OnboardingStep(image: "onboarding_img1", title:"Study without the stress" , descreption: "AI creates your perfect study schedule automatically."),
        OnboardingStep(image: "onboarding_img2", title:"Your time, perfetcly optimized" , descreption: "Sync your calender and let AI fit studying into your free time ."),
        OnboardingStep(image: "onboarding_img3", title:"Learn with your personal AI tutor" , descreption: "Summaries, explanation and smart study sessions-all in one place.")
    ]
    public var isLastPage : Bool {
        currentPage == steps.count - 1
    }
    public func nextPage(){
        if currentPage < steps.count-1 {
            currentPage+=1
        }else{
            finishOnboarding()
        }
    }
        public func previousPage(){
            if currentPage>0{
                currentPage -= 1
            }
        }
        public func skip(){
            finishOnboarding()
        }
        private func finishOnboarding(){
            print("onboarding Finshed")
        }
    }

