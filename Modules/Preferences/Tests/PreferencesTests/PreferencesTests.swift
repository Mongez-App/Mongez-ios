import XCTest
@testable import Preferences

@MainActor
final class PreferencesTests: XCTestCase {
    func testTogglingADaySelectsIt() {
        let viewModel = PreferencesViewModel()

        viewModel.toggleDay(.monday)

        XCTAssertTrue(viewModel.isSelected(.monday))
    }

    func testTogglingASelectedDayDeselectsIt() {
        let viewModel = PreferencesViewModel()
        viewModel.toggleDay(.monday)

        viewModel.toggleDay(.monday)

        XCTAssertFalse(viewModel.isSelected(.monday))
    }

    func testNextStepAdvancesUntilLastStep() {
        let viewModel = PreferencesViewModel()

        viewModel.nextStep()
        XCTAssertEqual(viewModel.currentStep, 1)

        viewModel.nextStep()
        XCTAssertEqual(viewModel.currentStep, 2)
        XCTAssertTrue(viewModel.isLastStep)
    }
}
