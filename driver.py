import asyncio
from motivus.client import Client

task_definition = {
    # local build
    'wasm_path': "build/mypmmoda-0.1.0.wasm",
    'loader_path': "build/mypmmoda-0.1.0.js",
    # published build
    # 'algorithm': "mypmmoda",
    # 'algorithm_version': "0.1.0",
    'params': [1, 2]
}


async def main():
    motivus = await Client.connect()

    task_id = motivus.call_async(task_definition)
    task = motivus.select_task(task_id)
    return await task

result = asyncio.run(main())
print(result)
