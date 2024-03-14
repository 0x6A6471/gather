open Radix;

[@react.component]
let make = () => {
  <Dialog.root>
    <Dialog.trigger
      className="rounded-md bg-gray-900 px-2.5 py-1.5 text-sm font-medium text-white shadow-sm hover:bg-gray-800 float-right">
      {React.string("Add Guest")}
    </Dialog.trigger>
    <Dialog.portal>
      <Dialog.overlay
        className="fixed inset-0 z-50 bg-black/50 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
      />
      <Dialog.content
        className="fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 bg-white p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] rounded-lg md:w-full">
        <Dialog.title
          className="text-2xl font-semibold text-gray-900 text-center">
          {React.string("Add Guest")}
        </Dialog.title>
        <Dialog.close
          className="absolute top-2 right-2 h-6 w-6 text-gray-500 hover:bg-gray-100 hover:text-gray-700 p-1 rounded">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">
            <rect width="256" height="256" fill="none" />
            <line
              x1="200"
              y1="56"
              x2="56"
              y2="200"
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="16"
            />
            <line
              x1="200"
              y1="200"
              x2="56"
              y2="56"
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="16"
            />
          </svg>
        </Dialog.close>
      </Dialog.content>
    </Dialog.portal>
  </Dialog.root>;
};
