import SwiftUI
import DawnObjc
import MetalKit
/*

	Helper metal view, which automatically makes a webgpu surface
 
*/
public struct DawnView : View
{
	public init()
	{
	}
	
	public var body : some View
	{
		MetalView(clearColour: NSColor.green.cgColor)
	}
}


//	this is the delegate
//	is this where we want webgpu
class Coordinator : NSObject, MTKViewDelegate
{
	var parent: MetalView
	var metalDevice: MTLDevice!
	var metalCommandQueue: MTLCommandQueue!
	var context : CIContext
	var clearColour : CGColor
	var clearRgba : [CGFloat]
	{
		return clearColour.components ?? [1,0,1,1]
	}
	
	init(_ parent: MetalView,clearColour : CGColor)
	{
		self.clearColour = clearColour
		self.parent = parent
		
		if let metalDevice = MTLCreateSystemDefaultDevice()
		{
			self.metalDevice = metalDevice
		}
		self.metalCommandQueue = metalDevice.makeCommandQueue()!
		context = CIContext(mtlDevice: metalDevice)
		
		super.init()
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
	}
	
	/*
	 func draw(in view: MTKView) {
	 guard let drawable = view.currentDrawable else {
	 return
	 }
	 let commandBuffer = metalCommandQueue.makeCommandBuffer()
	 let rpd = view.currentRenderPassDescriptor
	 rpd?.colorAttachments[0].clearColor = MTLClearColorMake(0, 1, 0, 1)
	 rpd?.colorAttachments[0].loadAction = .clear
	 rpd?.colorAttachments[0].storeAction = .store
	 let re = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd!)
	 re?.endEncoding()
	 commandBuffer?.present(drawable)
	 commandBuffer?.commit()
	 }
	 */
	func draw(in view: MTKView)
	{
		guard let drawable = view.currentDrawable else {
			return
		}
		
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		let commandBuffer = metalCommandQueue.makeCommandBuffer()
		
		let rpd = view.currentRenderPassDescriptor
		rpd?.colorAttachments[0].clearColor = MTLClearColorMake( clearRgba[0], clearRgba[1], clearRgba[2], clearRgba[3] )
		rpd?.colorAttachments[0].loadAction = .clear
		rpd?.colorAttachments[0].storeAction = .store
		
		let re = commandBuffer?.makeRenderCommandEncoder(descriptor: rpd!)
		re?.endEncoding()
		/*
		 context.render((AppState.shared.rawImage ?? AppState.shared.rawImageOriginal)!,
		 to: drawable.texture,
		 commandBuffer: commandBuffer,
		 bounds: AppState.shared.rawImageOriginal!.extent,
		 colorSpace: colorSpace)
		 */
		commandBuffer?.present(drawable)
		commandBuffer?.commit()
	}
}


//	example metal view
//	gr: see https://github.com/NewChromantics/PopEngine/blob/1d2824161f44fa2fe6a4e239ba9082224c4b208f/src/PopEngineGui.swift#L241
//		for my XXXViewRepresentable abstraction for ios & macos and metal vs opengl
struct MetalView: NSViewRepresentable
{
	var clearColour : CGColor
	
	init(clearColour:CGColor)
	{
		self.clearColour = clearColour
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self,clearColour: clearColour)
	}
	func makeNSView(context: NSViewRepresentableContext<MetalView>) -> MTKView {
		let mtkView = MTKView()
		mtkView.delegate = context.coordinator
		mtkView.preferredFramesPerSecond = 60
		mtkView.enableSetNeedsDisplay = true
		if let metalDevice = MTLCreateSystemDefaultDevice() {
			mtkView.device = metalDevice
		}
		mtkView.framebufferOnly = false
		mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
		mtkView.drawableSize = mtkView.frame.size
		mtkView.enableSetNeedsDisplay = true
		return mtkView
	}
	func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<MetalView>) {
	}
	
	
	
}


struct AppView_Previews: PreviewProvider
{
	static var previews: some View
	{
		VStack
		{
			MetalView(clearColour:NSColor.cyan.cgColor)
			
			DawnView()
		}
	}
}

